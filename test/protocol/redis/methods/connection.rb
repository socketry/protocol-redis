# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2021-2025, by Samuel Williams.

require "protocol/redis/methods_context"
require "protocol/redis/methods/connection"

describe Protocol::Redis::Methods::Connection do
	include_context Protocol::Redis::MethodsContext, Protocol::Redis::Methods::Connection
	
	let(:message) {"Hello, World!"}
	
	with "#auth" do
		it "generates correct arguments for password" do
			expect(object).to receive(:call).with("AUTH", "hunter2").and_return("OK")
			
			response = object.auth("hunter2")
			expect(response).to be_truthy
		end
		
		it "generates correct arguments for username & password" do
			expect(object).to receive(:call).with("AUTH", "AzureDiamond", "hunter2").and_return("OK")
			
			response = object.auth("AzureDiamond", "hunter2")
			expect(response).to be_truthy
		end
	end
	
	with "#echo" do
		it "can generate correct arguments" do
			expect(object).to receive(:call).with("ECHO", message).and_return(message)
			
			expect(object.echo(message)).to be == message
		end
	end
	
	with "#ping" do
		it "can generate correct arguments" do
			expect(object).to receive(:call).with("PING", message).and_return(message)
			
			expect(object.ping(message)).to be == message
		end
	end
	
	with "#quit" do
		it "can generate correct arguments" do
			expect(object).to receive(:call).with("QUIT").and_return("OK")
			
			expect(object.quit).to be == "OK"
		end
	end
end
