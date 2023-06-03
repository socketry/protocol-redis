# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2019-2023, by Samuel Williams.

require_relative 'error'

module Protocol
	module Redis
		class Connection
			CRLF = "\r\n".freeze
			
			def initialize(stream)
				@stream = stream
				
				# Number of requests sent:
				@count = 0
			end
			
			attr :stream
			
			# @attr [Integer] Number of requests sent.
			attr :count
			
			def close
				@stream.close
			end
			
			class << self
				alias client new
			end
			
			def flush
				@stream.flush
			end
			
			def closed?
				@stream.closed?
			end
			
			# The redis server doesn't want actual objects (e.g. integers) but only bulk strings. So, we inline it for performance.
			def write_request(arguments)
				write_lines("*#{arguments.size}")
				
				@count += 1
				
				arguments.each do |argument|
					string = argument.to_s
					
					write_lines("$#{string.bytesize}", string)
				end
			end
			
			def write_object(object)
				case object
				when String
					write_lines("$#{object.bytesize}", object)
				when Array
					write_array(object)
				when Integer
					write_lines(":#{object}")
				else
					write_object(object.to_redis)
				end
			end
			
			def read_data(length)
				buffer = @stream.read(length) or @stream.eof!
				
				# Eat trailing whitespace because length does not include the CRLF:
				@stream.read(2) or @stream.eof!
				
				return buffer
			end
			
			def read_object
				line = read_line or raise EOFError
				
				token = line.slice!(0, 1)
				
				case token
				when '$'
					length = line.to_i
					
					if length == -1
						return nil
					else
						return read_data(length)
					end
				when '*'
					count = line.to_i
					
					# Null array (https://redis.io/topics/protocol#resp-arrays):
					return nil if count == -1
					
					array = Array.new(count) {read_object}
					
					return array
				when ':'
					return line.to_i
				
				when '-'
					raise ServerError.new(line)
				
				when '+'
					return line
				
				else
					@stream.flush
					
					raise NotImplementedError, "Implementation for token #{token} missing"
				end
				
				# TODO: If an exception (e.g. Async::TimeoutError) propagates out of this function, perhaps @stream should be closed? Otherwise it might be in a weird state.
			end
			
			alias read_response read_object

			private

			# In the case of Redis, we do not want to perform a flush in every line,
			# because each Redis command contains several lines. Flushing once per
			# command is more efficient because it avoids unnecessary writes to the
			# socket.
			def write_lines(*arguments)
				if arguments.empty?
					@stream.write(CRLF)
				else
					arguments.each do |arg|
						@stream.write(arg)
						@stream.write(CRLF)
					end
				end
			end
			
			def read_line
				@stream.gets(CRLF, chomp: true)
			end
		end
	end
end
