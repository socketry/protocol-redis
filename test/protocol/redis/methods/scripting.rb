# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2023, by Nick Burwell.
# Copyright, 2023-2024, by Samuel Williams.

require "methods_context"
require "protocol/redis/methods/scripting"

describe Protocol::Redis::Methods::Scripting do
	include_context MethodsContext, Protocol::Redis::Methods::Scripting
	
	with "#eval" do
		let(:script) {"scriptname"}
		let(:key1) {"mykey1"}
		let(:value1) {"myvalue1"}
		let(:key2) {"mykey2"}
		let(:value2) {"myvalue2"}
		
		it "can generate correct arguments" do
			expect(object).to receive(:call).with("EVAL", script, 1, key1, value1)
			
			object.eval(script, 1, key1, value1)
		end
		
		it "can generate correct arguments with multiple keys and values" do
			expect(object).to receive(:call).with("EVAL", script, 2, key1, key2, value1, value2)
			
			object.eval(script, 2, key1, key2, value1, value2)
		end
	end
	
	with "#evalsha" do
		let(:sha1) {"scriptsha"}
		let(:key1) {"mykey1"}
		let(:value1) {"myvalue1"}
		let(:key2) {"mykey2"}
		let(:value2) {"myvalue2"}
		
		it "can generate correct arguments" do
			expect(object).to receive(:call).with("EVALSHA", sha1, 1, key1, value1)
			
			object.evalsha(sha1, 1, key1, value1)
		end
		
		it "can generate correct arguments with multiple keys and values" do
			expect(object).to receive(:call).with("EVALSHA", sha1, 2, key1, key2, value1, value2)
			
			object.evalsha(sha1, 2, key1, key2, value1, value2)
		end
	end
	
	with "#script" do
		with "#debug" do
			let(:mode) {"YES"}
			
			it "can generate correct arguments" do
				expect(object).to receive(:call).with("SCRIPT", "DEBUG", mode)
				
				object.script("DEBUG", mode)
			end
			
			it "will convert subcommand symbols to strings" do
				expect(object).to receive(:call).with("SCRIPT", "debug", mode)
				
				object.script(:debug, mode)
			end
		end
		
		with "#exists" do
			let(:sha1) {"2ef7bde608ce5404e97d5f042f95f89f1c232871"}
			
			it "can generate correct arguments" do
				expect(object).to receive(:call).with("SCRIPT", "EXISTS", sha1)
				
				object.script("EXISTS", sha1)
			end
		end
		
		with "#flush" do
			let(:mode) {"ASYNC"}
			
			it "can generate correct arguments" do
				expect(object).to receive(:call).with("SCRIPT", "FLUSH", mode)
				
				object.script("FLUSH", mode)
			end
		end
		
		with "#kill" do
			let(:sha1) {"2ef7bde608ce5404e97d5f042f95f89f1c232871"}
			
			it "can generate correct arguments" do
				expect(object).to receive(:call).with("SCRIPT", "KILL")
				
				object.script("KILL")
			end
		end
		
		with "#load" do
			let(:script) {"return 'Hello, world!'"}
			
			it "can generate correct arguments" do
				expect(object).to receive(:call).with("SCRIPT", "LOAD", script)
				
				object.script("LOAD", script)
			end
		end
	end
end
