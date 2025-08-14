# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2023, by Samuel Williams.

require "protocol/redis/cluster/methods/scripting"
require "protocol/redis/cluster/methods_context"

describe Protocol::Redis::Cluster::Methods::Scripting do
	include_context Protocol::Redis::Cluster::MethodsContext, Protocol::Redis::Cluster::Methods::Scripting
	
	let(:script) {"return redis.call('get', KEYS[1])"}
	let(:sha1) {"2ef7bde608ce5404e97d5f042f95f89f1c232871"}
	let(:key1) {"mykey1"}
	let(:key2) {"mykey2"}
	let(:value1) {"myvalue1"}
	let(:value2) {"myvalue2"}
	
	with "#eval" do
		it "can execute script with no keys" do
			expect(object).to receive(:call).with("EVAL", script, 0).and_return("OK")
			
			expect(object.eval(script, 0)).to be == "OK"
		end
		
		it "can execute script with single key" do
			expect(object).to receive(:call).with("EVAL", script, 1, key1, value1).and_return(value1)
			
			expect(object.eval(script, 1, key1, value1)).to be == value1
		end
		
		it "can execute script with multiple keys and values" do
			expect(object).to receive(:call).with("EVAL", script, 2, key1, key2, value1, value2).and_return([value1, value2])
			
			expect(object.eval(script, 2, key1, key2, value1, value2)).to be == [value1, value2]
		end
		
		it "can execute script with keys but no args" do
			expect(object).to receive(:call).with("EVAL", script, 1, key1).and_return(value1)
			
			expect(object.eval(script, 1, key1)).to be == value1
		end
		
		it "can execute script with role parameter" do
			expect(object).to receive(:call).with("EVAL", script, 1, key1).and_return(value1)
			
			expect(object.eval(script, 1, key1, role: :slave)).to be == value1
		end
	end
	
	with "#evalsha" do
		it "can execute script by SHA with no keys" do
			expect(object).to receive(:call).with("EVALSHA", sha1, 0).and_return("OK")
			
			expect(object.evalsha(sha1, 0)).to be == "OK"
		end
		
		it "can execute script by SHA with single key" do
			expect(object).to receive(:call).with("EVALSHA", sha1, 1, key1, value1).and_return(value1)
			
			expect(object.evalsha(sha1, 1, key1, value1)).to be == value1
		end
		
		it "can execute script by SHA with multiple keys and values" do
			expect(object).to receive(:call).with("EVALSHA", sha1, 2, key1, key2, value1, value2).and_return([value1, value2])
			
			expect(object.evalsha(sha1, 2, key1, key2, value1, value2)).to be == [value1, value2]
		end
		
		it "can execute script by SHA with keys but no args" do
			expect(object).to receive(:call).with("EVALSHA", sha1, 1, key1).and_return(value1)
			
			expect(object.evalsha(sha1, 1, key1)).to be == value1
		end
		
		it "can execute script by SHA with role parameter" do
			expect(object).to receive(:call).with("EVALSHA", sha1, 1, key1).and_return(value1)
			
			expect(object.evalsha(sha1, 1, key1, role: :slave)).to be == value1
		end
	end
	
	with "#script" do
		with "#debug" do
			let(:mode) {"YES"}
			
			it "can execute script debug command" do
				expect(object).to receive(:call).with("SCRIPT", "DEBUG", mode).and_return("OK")
				
				expect(object.script("DEBUG", mode)).to be == "OK"
			end
		end
		
		with "#exists" do
			it "can check if script exists" do
				expect(object).to receive(:call).with("SCRIPT", "EXISTS", sha1).and_return([1])
				
				expect(object.script("EXISTS", sha1)).to be == [1]
			end
			
			it "can check multiple scripts" do
				sha2 = "3bf7cde608ce5404e97d5f042f95f89f1c232872"
				expect(object).to receive(:call).with("SCRIPT", "EXISTS", sha1, sha2).and_return([1, 0])
				
				expect(object.script("EXISTS", sha1, sha2)).to be == [1, 0]
			end
		end
		
		with "#flush" do
			it "can flush scripts" do
				expect(object).to receive(:call).with("SCRIPT", "FLUSH").and_return("OK")
				
				expect(object.script("FLUSH")).to be == "OK"
			end
			
			it "can flush scripts with mode" do
				expect(object).to receive(:call).with("SCRIPT", "FLUSH", "ASYNC").and_return("OK")
				
				expect(object.script("FLUSH", "ASYNC")).to be == "OK"
			end
		end
		
		with "#kill" do
			it "can kill running script" do
				expect(object).to receive(:call).with("SCRIPT", "KILL").and_return("OK")
				
				expect(object.script("KILL")).to be == "OK"
			end
		end
		
		with "#load" do
			it "can load script" do
				expect(object).to receive(:call).with("SCRIPT", "LOAD", script).and_return(sha1)
				
				expect(object.script("LOAD", script)).to be == sha1
			end
		end
		
		with "role parameter" do
			it "can execute with slave role" do
				expect(object).to receive(:call).with("SCRIPT", "EXISTS", sha1).and_return([1])
				
				expect(object.script("EXISTS", sha1, role: :slave)).to be == [1]
			end
		end
	end
end
