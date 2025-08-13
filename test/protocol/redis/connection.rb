# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2019-2024, by Samuel Williams.

require "protocol/redis/connection"
require "connection_context"

describe Protocol::Redis::Connection do
	include_context ConnectionContext
	
	with "#initialize" do
		it "initializes with stream and zero count" do
			connection = Protocol::Redis::Connection.new(sockets.first)
			
			expect(connection.stream).to be == sockets.first
			expect(connection.count).to be == 0
		end
	end
	
	with ".client" do
		it "is an alias for new" do
			expect(Protocol::Redis::Connection.client(sockets.first)).to be_a(Protocol::Redis::Connection)
		end
	end
	
	with "#flush" do
		it "flushes the underlying stream" do
			expect(client.stream).to receive(:flush)
			
			client.flush
		end
	end
	
	with "#close" do
		it "closes the underlying stream" do
			expect(client.stream).to receive(:close)
			
			client.close
		end
	end
	
	with "#closed?" do
		it "returns the stream's closed status" do
			expect(client.stream).to receive(:closed?).and_return(true)
			
			expect(client.closed?).to be == true
		end
		
		it "returns false when stream is open" do
			expect(client.stream).to receive(:closed?).and_return(false)
			
			expect(client.closed?).to be == false
		end
	end
	
	with "#write_request" do
		it "writes Redis request with argument count and increments counter" do
			initial_count = client.count
			
			client.write_request(["SET", "key", "value"])
			
			expect(client.count).to be == initial_count + 1
			
			# The server should be able to read the complete request as an array
			result = server.read_object
			expect(result).to be == ["SET", "key", "value"]
		end
		
		it "handles empty arguments" do
			initial_count = client.count
			
			client.write_request([])
			
			expect(client.count).to be == initial_count + 1
			
			# Should read an empty array
			response = server.read_object
			expect(response).to be == []
		end
		
		it "converts arguments to strings" do
			client.write_request([123, :symbol, true])
			
			expect(client.count).to be == 1
			
			# Read the array with converted string arguments
			result = server.read_object
			expect(result).to be == ["123", "symbol", "true"]
		end
	end
	
	with "#write_object" do
		it "writes strings with length prefix" do
			client.write_object("Hello World!")
			
			expect(server.read_object).to be == "Hello World!"
		end
		
		it "writes integers with colon prefix" do
			client.write_object(42)
			
			expect(server.read_object).to be == 42
		end
		
		it "writes arrays recursively" do
			client.write_object(["hello", 123, ["nested", "array"]])
			
			result = server.read_object
			expect(result).to be == ["hello", 123, ["nested", "array"]]
		end
		
		it "writes empty arrays" do
			client.write_object([])
			
			result = server.read_object
			expect(result).to be == []
		end
		
		it "writes objects with to_redis method" do
			custom_object = Object.new
			def custom_object.to_redis
				"custom_value"
			end
			
			client.write_object(custom_object)
			
			expect(server.read_object).to be == "custom_value"
		end
		
		it "writes nested objects with to_redis method" do
			custom_object = Object.new
			def custom_object.to_redis
				[1, 2, 3]
			end
			
			client.write_object(custom_object)
			
			expect(server.read_object).to be == [1, 2, 3]
		end
	end
	
	with "#read_object" do
		it "reads string objects" do
			client.write_object("test string")
			
			expect(server.read_object).to be == "test string"
		end
		
		it "reads nil strings (length -1)" do
			# Manually write a nil bulk string: $-1\r\n
			client.stream.write("$-1\r\n")
			client.stream.flush
			
			expect(server.read_object).to be_nil
		end
		
		it "reads integer objects" do
			client.write_object(999)
			
			expect(server.read_object).to be == 999
		end
		
		it "reads negative integers" do
			client.write_object(-42)
			
			expect(server.read_object).to be == -42
		end
		
		it "reads simple string responses" do
			# Write a simple string: +OK\r\n
			client.stream.write("+OK\r\n")
			client.stream.flush
			
			expect(server.read_object).to be == "OK"
		end
		
		it "reads array objects" do
			client.write_object(["one", "two", "three"])
			
			result = server.read_object
			expect(result).to be == ["one", "two", "three"]
		end
		
		it "reads nil arrays (count -1)" do
			# Manually write a nil array: *-1\r\n
			client.stream.write("*-1\r\n")
			client.stream.flush
			
			expect(server.read_object).to be_nil
		end
		
		it "reads nested arrays" do
			client.write_object([1, [2, 3], 4])
			
			result = server.read_object
			expect(result).to be == [1, [2, 3], 4]
		end
		
		it "reads empty strings" do
			client.write_object("")
			
			expect(server.read_object).to be == ""
		end
		
		it "raises ServerError for error responses" do
			# Write an error response: -ERR something went wrong\r\n
			client.stream.write("-ERR something went wrong\r\n")
			client.stream.flush
			
			expect do
				server.read_object
			end.to raise_exception(Protocol::Redis::ServerError) do |exception|
				expect(exception.message).to be == "ERR something went wrong"
			end
		end
		
		it "raises NotImplementedError for unknown tokens" do
			# Write an unknown token response
			client.stream.write("?unknown\r\n")
			client.stream.flush
			
			expect do
				server.read_object
			end.to raise_exception(NotImplementedError) do |exception|
				expect(exception.message).to be == "Implementation for token ? missing"
			end
		end
		
		it "raises EOFError when stream ends unexpectedly" do
			# Close the client stream to simulate EOF
			client.stream.close
			
			expect do
				server.read_object
			end.to raise_exception(EOFError)
		end
	end
	
	with "#read_response" do
		it "is an alias for read_object" do
			client.write_object("test")
			
			expect(server.read_response).to be == "test"
		end
	end
	
	with "#read_data" do
		it "reads specified length of data" do
			# Write data followed by CRLF
			client.stream.write("hello\r\n")
			client.stream.flush
			
			result = server.read_data(5)
			expect(result).to be == "hello"
		end
		
		it "handles EOF conditions gracefully" do
			# Test by closing the stream  
			client.stream.close
			
			expect do
				server.read_data(10)
			end.to raise_exception
		end
	end
	
	with "private methods" do
		# Testing private methods through public interface
		
		it "write_lines handles empty arguments" do
			# Force empty arguments by manually creating a scenario
			# We can test this by sending a direct command
			connection = Protocol::Redis::Connection.new(sockets.first)
			
			# Call private method indirectly by ensuring empty write_lines call
			connection.send(:write_lines)
			
			# Read the CRLF from the other end
			result = sockets.last.read(2)
			expect(result).to be == "\r\n"
		end
		
		it "write_lines handles multiple arguments" do
			# This is tested indirectly through write_object and write_request
			client.write_object("test")
			expect(server.read_object).to be == "test"
		end
		
		it "read_line handles stream EOF" do
			# Close the stream to test EOF handling in read_line
			client.stream.close
			
			expect do
				server.read_object
			end.to raise_exception(EOFError)
		end
	end
	
	with "complex scenarios" do
		it "handles mixed data types in arrays" do
			mixed_array = ["string", 42, ["nested", 123]]
			client.write_object(mixed_array)
			
			result = server.read_object
			expect(result).to be == ["string", 42, ["nested", 123]]
		end
		
		it "handles nil values properly" do
			client.write_object(nil)
			
			result = server.read_object
			expect(result).to be_nil
		end
		
		it "handles multiple sequential operations" do
			# Test multiple writes and reads
			client.write_object("first")
			client.write_object(123)
			client.write_object(["array", "data"])
			
			expect(server.read_object).to be == "first"
			expect(server.read_object).to be == 123
			expect(server.read_object).to be == ["array", "data"]
		end
		
		it "handles large strings" do
			large_string = "x" * 1000
			client.write_object(large_string)
			
			expect(server.read_object).to be == large_string
		end
		
		it "maintains connection state across operations" do
			initial_count = client.count
			
			client.write_request(["CMD1", "arg1"])
			client.write_request(["CMD2", "arg2", "arg3"])
			
			expect(client.count).to be == initial_count + 2
		end
	end
end
