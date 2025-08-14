# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2023, by Samuel Williams.

require "protocol/redis/cluster/methods/streams"
require "protocol/redis/cluster/methods_context"

describe Protocol::Redis::Cluster::Methods::Streams do
	include_context Protocol::Redis::Cluster::MethodsContext, Protocol::Redis::Cluster::Methods::Streams
	
	let(:stream_key) {"mystream"}
	let(:group_name) {"mygroup"}
	let(:consumer_name) {"myconsumer"}
	let(:entry_id) {"1000001234-0"}
	
	with "#xinfo" do
		it "can get stream information" do
			expect(object).to receive(:call).with("XINFO", "STREAM", stream_key).and_return([])
			
			expect(object.xinfo("STREAM", stream_key)).to be == []
		end
	end
	
	with "#xadd" do
		it "can add entries to a stream" do
			expect(object).to receive(:call).with("XADD", stream_key, "*", "field", "value").and_return(entry_id)
			
			expect(object.xadd(stream_key, "*", "field", "value")).to be == entry_id
		end
	end
	
	with "#xtrim" do
		it "can trim a stream" do
			expect(object).to receive(:call).with("XTRIM", stream_key, "MAXLEN", "1000").and_return(5)
			
			expect(object.xtrim(stream_key, "MAXLEN", "1000")).to be == 5
		end
	end
	
	with "#xdel" do
		it "can delete entries from a stream" do
			expect(object).to receive(:call).with("XDEL", stream_key, entry_id).and_return(1)
			
			expect(object.xdel(stream_key, entry_id)).to be == 1
		end
	end
	
	with "#xrange" do
		it "can get a range of entries" do
			expect(object).to receive(:call).with("XRANGE", stream_key, "-", "+").and_return([])
			
			expect(object.xrange(stream_key, "-", "+")).to be == []
		end
	end
	
	with "#xrevrange" do
		it "can get a reverse range of entries" do
			expect(object).to receive(:call).with("XREVRANGE", stream_key, "+", "-").and_return([])
			
			expect(object.xrevrange(stream_key, "+", "-")).to be == []
		end
	end
	
	with "#xlen" do
		it "can get stream length" do
			expect(object).to receive(:call).with("XLEN", stream_key).and_return(10)
			
			expect(object.xlen(stream_key)).to be == 10
		end
	end
	
	with "#xread" do
		it "can read from streams" do
			expect(object).to receive(:call).with("XREAD", "STREAMS", stream_key, "0").and_return([])
			
			expect(object.xread("STREAMS", stream_key, "0")).to be == []
		end
	end
	
	with "#xgroup" do
		it "can create consumer groups" do
			expect(object).to receive(:call).with("XGROUP", "CREATE", stream_key, group_name, "$").and_return("OK")
			
			expect(object.xgroup("CREATE", stream_key, group_name, "$")).to be == "OK"
		end
	end
	
	with "#xreadgroup" do
		it "can read from consumer groups" do
			expect(object).to receive(:call).with("XREADGROUP", "GROUP", group_name, consumer_name, "STREAMS", stream_key, ">").and_return([])
			
			expect(object.xreadgroup("GROUP", group_name, consumer_name, "STREAMS", stream_key, ">")).to be == []
		end
	end
	
	with "#xack" do
		it "can acknowledge messages" do
			expect(object).to receive(:call).with("XACK", stream_key, group_name, entry_id).and_return(1)
			
			expect(object.xack(stream_key, group_name, entry_id)).to be == 1
		end
	end
	
	with "#xclaim" do
		it "can claim messages" do
			expect(object).to receive(:call).with("XCLAIM", stream_key, group_name, consumer_name, "60000", entry_id).and_return([])
			
			expect(object.xclaim(stream_key, group_name, consumer_name, "60000", entry_id)).to be == []
		end
	end
	
	with "#xpending" do
		it "can get pending message information" do
			expect(object).to receive(:call).with("XPENDING", stream_key, group_name).and_return([])
			
			expect(object.xpending(stream_key, group_name)).to be == []
		end
	end
end
