# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2025, by Samuel Williams.

require "protocol/redis/methods_context"
require "protocol/redis/methods/sets"

describe Protocol::Redis::Methods::Sets do
	include_context Protocol::Redis::MethodsContext, Protocol::Redis::Methods::Sets
	
	let(:set_name) {"set_test"}
	let(:set_name2) {"set_test2"}
	let(:dest_set) {"dest_set"}
	let(:member) {"member1"}
	let(:member2) {"member2"}
	let(:member3) {"member3"}
	
	with "#sadd" do
		it "can generate correct arguments with single member" do
			expect(object).to receive(:call).with("SADD", set_name, member).and_return(1)
			
			expect(object.sadd(set_name, member)).to be == 1
		end
		
		it "can generate correct arguments with multiple members" do
			expect(object).to receive(:call).with("SADD", set_name, member, member2).and_return(2)
			
			expect(object.sadd(set_name, member, member2)).to be == 2
		end
	end
	
	with "#scard" do
		it "can generate correct arguments" do
			expect(object).to receive(:call).with("SCARD", set_name).and_return(3)
			
			expect(object.scard(set_name)).to be == 3
		end
	end
	
	with "#sdiff" do
		it "can generate correct arguments with multiple sets" do
			expect(object).to receive(:call).with("SDIFF", set_name, set_name2).and_return([member])
			
			expect(object.sdiff(set_name, set_name2)).to be == [member]
		end
	end
	
	with "#sdiffstore" do
		it "can generate correct arguments" do
			expect(object).to receive(:call).with("SDIFFSTORE", dest_set, set_name, set_name2).and_return(1)
			
			expect(object.sdiffstore(dest_set, set_name, set_name2)).to be == 1
		end
	end
	
	with "#sinter" do
		it "can generate correct arguments with multiple sets" do
			expect(object).to receive(:call).with("SINTER", set_name, set_name2).and_return([member])
			
			expect(object.sinter(set_name, set_name2)).to be == [member]
		end
	end
	
	with "#sinterstore" do
		it "can generate correct arguments" do
			expect(object).to receive(:call).with("SINTERSTORE", dest_set, set_name, set_name2).and_return(1)
			
			expect(object.sinterstore(dest_set, set_name, set_name2)).to be == 1
		end
	end
	
	with "#sismember" do
		it "can generate correct arguments" do
			expect(object).to receive(:call).with("SISMEMBER", set_name, member).and_return(1)
			
			expect(object.sismember(set_name, member)).to be == 1
		end
	end
	
	with "#smembers" do
		it "can generate correct arguments" do
			expect(object).to receive(:call).with("SMEMBERS", set_name).and_return([member, member2, member3])
			
			expect(object.smembers(set_name)).to be == [member, member2, member3]
		end
	end
	
	with "#smove" do
		it "can generate correct arguments" do
			expect(object).to receive(:call).with("SMOVE", set_name, dest_set, member).and_return(1)
			
			expect(object.smove(set_name, dest_set, member)).to be == 1
		end
	end
	
	with "#spop" do
		it "can generate correct arguments with single member" do
			expect(object).to receive(:call).with("SPOP", set_name).and_return(member)
			
			expect(object.spop(set_name)).to be == member
		end
		
		it "can generate correct arguments with count" do
			expect(object).to receive(:call).with("SPOP", set_name, 2).and_return([member, member2])
			
			expect(object.spop(set_name, 2)).to be == [member, member2]
		end
	end
	
	with "#srandmember" do
		it "can generate correct arguments with single member" do
			expect(object).to receive(:call).with("SRANDMEMBER", set_name).and_return(member)
			
			expect(object.srandmember(set_name)).to be == member
		end
		
		it "can generate correct arguments with count" do
			expect(object).to receive(:call).with("SRANDMEMBER", set_name, 2).and_return([member, member2])
			
			expect(object.srandmember(set_name, 2)).to be == [member, member2]
		end
	end
	
	with "#srem" do
		it "can generate correct arguments with single member" do
			expect(object).to receive(:call).with("SREM", set_name, member).and_return(1)
			
			expect(object.srem(set_name, member)).to be == 1
		end
		
		it "can generate correct arguments with multiple members" do
			expect(object).to receive(:call).with("SREM", set_name, member, member2).and_return(2)
			
			expect(object.srem(set_name, member, member2)).to be == 2
		end
	end
	
	with "#sunion" do
		it "can generate correct arguments with multiple sets" do
			expect(object).to receive(:call).with("SUNION", set_name, set_name2).and_return([member, member2, member3])
			
			expect(object.sunion(set_name, set_name2)).to be == [member, member2, member3]
		end
	end
	
	with "#sunionstore" do
		it "can generate correct arguments" do
			expect(object).to receive(:call).with("SUNIONSTORE", dest_set, set_name, set_name2).and_return(3)
			
			expect(object.sunionstore(dest_set, set_name, set_name2)).to be == 3
		end
	end
	
	with "#sscan" do
		it "can generate correct arguments" do
			expect(object).to receive(:call).with("SSCAN", set_name, 0).and_return([0, [member, member2]])
			
			expect(object.sscan(set_name, 0)).to be == [0, [member, member2]]
		end
		
		it "can generate correct arguments with options" do
			expect(object).to receive(:call).with("SSCAN", set_name, "0", "MATCH", "test*", "COUNT", 10).and_return(["0", []])
			
			expect(object.sscan(set_name, "0", "MATCH", "test*", "COUNT", 10)).to be == ["0", []]
		end
	end
end
