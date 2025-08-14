# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2023, by Samuel Williams.

require "protocol/redis/cluster/methods/strings"
require "protocol/redis/cluster/methods_context"

describe Protocol::Redis::Cluster::Methods::Strings do
	include_context Protocol::Redis::Cluster::MethodsContext, Protocol::Redis::Cluster::Methods::Strings
	
	let(:key) {"mykey"}
	let(:value) {"myvalue"}
	let(:other_key) {"otherkey"}
	
	with "#append" do
		it "can append to a key" do
			expect(object).to receive(:call).with("APPEND", key, value).and_return(7)
			
			expect(object.append(key, value)).to be == 7
		end
	end
	
	with "#bitcount" do
		it "can count bits in a key" do
			expect(object).to receive(:call).with("BITCOUNT", key).and_return(5)
			
			expect(object.bitcount(key)).to be == 5
		end
		
		it "can count bits in a range" do
			expect(object).to receive(:call).with("BITCOUNT", key, 0, 1).and_return(3)
			
			expect(object.bitcount(key, 0, 1)).to be == 3
		end
	end
	
	with "#decr" do
		it "can decrement a key" do
			expect(object).to receive(:call).with("DECR", key).and_return(9)
			
			expect(object.decr(key)).to be == 9
		end
	end
	
	with "#decrby" do
		it "can decrement a key by amount" do
			expect(object).to receive(:call).with("DECRBY", key, 5).and_return(5)
			
			expect(object.decrby(key, 5)).to be == 5
		end
	end
	
	with "#get" do
		it "can get a key value" do
			expect(object).to receive(:call).with("GET", key).and_return(value)
			
			expect(object.get(key)).to be == value
		end
	end
	
	with "#getbit" do
		it "can get a bit value" do
			expect(object).to receive(:call).with("GETBIT", key, 7).and_return(1)
			
			expect(object.getbit(key, 7)).to be == 1
		end
	end
	
	with "#getrange" do
		it "can get a range of string" do
			expect(object).to receive(:call).with("GETRANGE", key, 0, 3).and_return("myva")
			
			expect(object.getrange(key, 0, 3)).to be == "myva"
		end
	end
	
	with "#getset" do
		it "can get and set a key" do
			expect(object).to receive(:call).with("GETSET", key, "newvalue").and_return(value)
			
			expect(object.getset(key, "newvalue")).to be == value
		end
	end
	
	with "#incr" do
		it "can increment a key" do
			expect(object).to receive(:call).with("INCR", key).and_return(11)
			
			expect(object.incr(key)).to be == 11
		end
	end
	
	with "#incrby" do
		it "can increment a key by amount" do
			expect(object).to receive(:call).with("INCRBY", key, 5).and_return(15)
			
			expect(object.incrby(key, 5)).to be == 15
		end
	end
	
	with "#incrbyfloat" do
		it "can increment a key by float amount" do
			expect(object).to receive(:call).with("INCRBYFLOAT", key, 2.5).and_return("12.5")
			
			expect(object.incrbyfloat(key, 2.5)).to be == "12.5"
		end
	end
	
	with "#mget" do
		it "returns empty array for no keys" do
			expect(object.mget()).to be == []
		end
		
		it "can get multiple keys" do
			expect(object).to receive(:call).with("MGET", key, other_key).and_return([value, "othervalue"])
			
			expect(object.mget(key, other_key)).to be == [value, "othervalue"]
		end
	end
	
	with "#mset" do
		it "can set multiple keys" do
			pairs = {key => value, other_key => "othervalue"}
			expect(object).to receive(:call).with("MSET", key, value, other_key, "othervalue").and_return("OK")
			
			expect(object.mset(pairs)).to be == "OK"
		end
	end
	
	with "#msetnx" do
		it "can set multiple keys if none exist" do
			pairs = {key => value, other_key => "othervalue"}
			expect(object).to receive(:call).with("MSETNX", key, value, other_key, "othervalue").and_return(1)
			
			expect(object.msetnx(pairs)).to be == 1
		end
	end
	
	with "#psetex" do
		it "can set key with milliseconds expiration" do
			expect(object).to receive(:call).with("PSETEX", key, 1000, value).and_return("OK")
			
			expect(object.psetex(key, 1000, value)).to be == "OK"
		end
	end
	
	with "#set" do
		it "can set a key" do
			expect(object).to receive(:call).with("SET", key, value).and_return("OK")
			
			expect(object.set(key, value)).to be == "OK"
		end
		
		it "can set with expiration and update options" do
			expect(object).to receive(:call).with("SET", key, value, "EX", 60, "XX").and_return("OK")
			
			expect(object.set(key, value, update: true, seconds: 60)).to be == "OK"
		end
		
		it "can set with milliseconds expiration" do
			expect(object).to receive(:call).with("SET", key, value, "PX", 1000).and_return("OK")
			
			expect(object.set(key, value, milliseconds: 1000)).to be == "OK"
		end
		
		it "can set with NX option" do
			expect(object).to receive(:call).with("SET", key, value, "NX").and_return("OK")
			
			expect(object.set(key, value, update: false)).to be == "OK"
		end
	end
	
	with "#setbit" do
		it "can set a bit value" do
			expect(object).to receive(:call).with("SETBIT", key, 7, 1).and_return(0)
			
			expect(object.setbit(key, 7, 1)).to be == 0
		end
	end
	
	with "#setex" do
		it "can set key with seconds expiration" do
			expect(object).to receive(:call).with("SETEX", key, 60, value).and_return("OK")
			
			expect(object.setex(key, 60, value)).to be == "OK"
		end
	end
	
	with "#setnx" do
		it "can set key only if not exists" do
			expect(object).to receive(:call).with("SETNX", key, value).and_return(1)
			
			expect(object.setnx(key, value)).to be == true
		end
		
		it "returns false when key exists" do
			expect(object).to receive(:call).with("SETNX", key, value).and_return(0)
			
			expect(object.setnx(key, value)).to be == false
		end
	end
	
	with "#setrange" do
		it "can set range of string" do
			expect(object).to receive(:call).with("SETRANGE", key, 6, "Redis").and_return(11)
			
			expect(object.setrange(key, 6, "Redis")).to be == 11
		end
	end
	
	with "#strlen" do
		it "can get string length" do
			expect(object).to receive(:call).with("STRLEN", key).and_return(7)
			
			expect(object.strlen(key)).to be == 7
		end
	end
end
