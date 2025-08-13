# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2019-2023, by Samuel Williams.
# Copyright, 2020, by Salim Semaoune.

require "methods_context"
require "protocol/redis/methods/lists"

describe Protocol::Redis::Methods::Lists do
	include_context MethodsContext, Protocol::Redis::Methods::Lists
	
	let(:list_name) {"list_test"}
	let(:source_list) {"source_list"}
	let(:dest_list) {"dest_list"}
	let(:value) {"value1"}
	let(:value2) {"value2"}
	let(:pivot) {"pivot"}
	let(:index) {0}
	let(:count) {1}
	let(:timeout) {5}
	
	with "#blpop" do
		it "can generate correct arguments with single key" do
			expect(object).to receive(:call).with("BLPOP", list_name, 0).and_return([list_name, value])
			
			expect(object.blpop(list_name)).to be == [list_name, value]
		end
		
		it "can generate correct arguments with multiple keys" do
			expect(object).to receive(:call).with("BLPOP", list_name, source_list, timeout).and_return([list_name, value])
			
			expect(object.blpop(list_name, source_list, timeout: timeout)).to be == [list_name, value]
		end
	end
	
	with "#brpop" do
		it "can generate correct arguments with single key" do
			expect(object).to receive(:call).with("BRPOP", list_name, 0).and_return([list_name, value])
			
			expect(object.brpop(list_name)).to be == [list_name, value]
		end
		
		it "can generate correct arguments with multiple keys" do
			expect(object).to receive(:call).with("BRPOP", list_name, source_list, timeout).and_return([list_name, value])
			
			expect(object.brpop(list_name, source_list, timeout: timeout)).to be == [list_name, value]
		end
	end
	
	with "#brpoplpush" do
		it "can generate correct arguments" do
			expect(object).to receive(:call).with("BRPOPLPUSH", source_list, dest_list, timeout).and_return(value)
			
			expect(object.brpoplpush(source_list, dest_list, timeout)).to be == value
		end
	end
	
	with "#lindex" do
		it "can generate correct arguments" do
			expect(object).to receive(:call).with("LINDEX", list_name, index).and_return(value)
			
			expect(object.lindex(list_name, index)).to be == value
		end
	end
	
	with "#linsert" do
		it "can generate correct arguments with before position" do
			expect(object).to receive(:call).with("LINSERT", list_name, "BEFORE", pivot, value).and_return(2)
			
			expect(object.linsert(list_name, :before, pivot, value)).to be == 2
		end
		
		it "can generate correct arguments with after position" do
			expect(object).to receive(:call).with("LINSERT", list_name, "AFTER", pivot, value).and_return(2)
			
			expect(object.linsert(list_name, :after, pivot, value)).to be == 2
		end
	end
	
	with "#llen" do
		it "can generate correct arguments" do
			expect(object).to receive(:call).with("LLEN", list_name).and_return(3)
			
			expect(object.llen(list_name)).to be == 3
		end
	end
	
	with "#lpop" do
		it "can generate correct arguments" do
			expect(object).to receive(:call).with("LPOP", list_name).and_return(value)
			
			expect(object.lpop(list_name)).to be == value
		end
	end
	
	with "#lpush" do
		it "can generate correct arguments with single value" do
			expect(object).to receive(:call).with("LPUSH", list_name, value).and_return(1)
			
			expect(object.lpush(list_name, value)).to be == 1
		end
		
		it "can generate correct arguments with multiple values" do
			expect(object).to receive(:call).with("LPUSH", list_name, value, value2).and_return(2)
			
			expect(object.lpush(list_name, value, value2)).to be == 2
		end
		
		it "can handle array of values" do
			expect(object).to receive(:call).with("LPUSH", list_name, value, value2).and_return(2)
			
			expect(object.lpush(list_name, [value, value2])).to be == 2
		end
	end
	
	with "#lpushx" do
		it "can generate correct arguments" do
			expect(object).to receive(:call).with("LPUSHX", list_name, value).and_return(1)
			
			expect(object.lpushx(list_name, value)).to be == 1
		end
	end
	
	with "#lrange" do
		it "can generate correct arguments" do
			expect(object).to receive(:call).with("LRANGE", list_name, 0, -1).and_return([value, value2])
			
			expect(object.lrange(list_name, 0, -1)).to be == [value, value2]
		end
	end
	
	with "#lrem" do
		it "can generate correct arguments" do
			expect(object).to receive(:call).with("LREM", list_name, count, value).and_return(1)
			
			expect(object.lrem(list_name, count, value)).to be == 1
		end
	end
	
	with "#lset" do
		it "can generate correct arguments" do
			expect(object).to receive(:call).with("LSET", list_name, index, value).and_return("OK")
			
			expect(object.lset(list_name, index, value)).to be == "OK"
		end
	end
	
	with "#ltrim" do
		it "can generate correct arguments" do
			expect(object).to receive(:call).with("LTRIM", list_name, 0, 2).and_return("OK")
			
			expect(object.ltrim(list_name, 0, 2)).to be == "OK"
		end
	end
	
	with "#rpop" do
		it "can generate correct arguments" do
			expect(object).to receive(:call).with("RPOP", list_name).and_return(value)
			
			expect(object.rpop(list_name)).to be == value
		end
	end
	
	with "#rpoplpush" do
		it "can generate correct arguments with different lists" do
			expect(object).to receive(:call).with("RPOPLPUSH", source_list, dest_list).and_return(value)
			
			expect(object.rpoplpush(source_list, dest_list)).to be == value
		end
		
		it "can generate correct arguments with same list (default)" do
			expect(object).to receive(:call).with("RPOPLPUSH", source_list, source_list).and_return(value)
			
			expect(object.rpoplpush(source_list)).to be == value
		end
	end
	
	with "#rpush" do
		it "can generate correct arguments with single value" do
			expect(object).to receive(:call).with("RPUSH", list_name, value).and_return(1)
			
			expect(object.rpush(list_name, value)).to be == 1
		end
		
		it "can generate correct arguments with multiple values" do
			expect(object).to receive(:call).with("RPUSH", list_name, value, value2).and_return(2)
			
			expect(object.rpush(list_name, value, value2)).to be == 2
		end
		
		it "can handle array of values" do
			expect(object).to receive(:call).with("RPUSH", list_name, value, value2).and_return(2)
			
			expect(object.rpush(list_name, [value, value2])).to be == 2
		end
	end
	
	with "#rpushx" do
		it "can generate correct arguments" do
			expect(object).to receive(:call).with("RPUSHX", list_name, value).and_return(1)
			
			expect(object.rpushx(list_name, value)).to be == 1
		end
	end
end
