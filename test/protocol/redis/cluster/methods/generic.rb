# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2025, by Samuel Williams.

require "protocol/redis/cluster/methods/generic"
require "protocol/redis/cluster/methods_context"

describe Protocol::Redis::Cluster::Methods::Generic do
	include_context Protocol::Redis::Cluster::MethodsContext, Protocol::Redis::Cluster::Methods::Generic
	
	with "#del" do
		it "returns 0 for empty keys" do
			expect(object.del).to be == 0
		end
		
		it "can delete single key" do
			expect(object).to receive(:call).with("DEL", "key1").and_return(1)
			
			expect(object.del("key1")).to be == 1
		end
		
		it "can delete multiple keys" do
			expect(object).to receive(:call).with("DEL", "key1", "key2").and_return(2)
			
			expect(object.del("key1", "key2")).to be == 2
		end
	end
	
	with "#get" do
		it "can get a key value" do
			expect(object).to receive(:call).with("GET", "mykey").and_return("myvalue")
			
			expect(object.get("mykey")).to be == "myvalue"
		end
	end
	
	with "#set" do
		it "can set a key value" do
			expect(object).to receive(:call).with("SET", "mykey", "myvalue").and_return("OK")
			
			expect(object.set("mykey", "myvalue")).to be == "OK"
		end
	end
	
	with "#exists" do
		it "returns 0 for empty keys" do
			expect(object.exists).to be == 0
		end
		
		it "can check if key exists" do
			expect(object).to receive(:call).with("EXISTS", "key1").and_return(1)
			
			expect(object.exists("key1")).to be == 1
		end
	end
	
	with "#mget" do
		it "returns empty array for no keys" do
			expect(object.mget).to be == []
		end
		
		it "can get multiple keys" do
			expect(object).to receive(:call).with("MGET", "key1", "key2").and_return(["value1", "value2"])
			
			expect(object.mget("key1", "key2")).to be == ["value1", "value2"]
		end
	end
end
