# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2020, by Dimitry Chopey.
# Copyright, 2020-2023, by Samuel Williams.

require 'methods_context'
require 'protocol/redis/methods/sorted_sets'

describe Protocol::Redis::Methods::SortedSets do
	include_context MethodsContext, Protocol::Redis::Methods::SortedSets
	let(:set_name) {'test'}
	
	with '#zadd' do
		let(:timestamp) { Time.now.to_f }
		
		it "can generate correct arguments" do
			expect(object).to receive(:call).with('ZADD', set_name, timestamp, 'payload')
			
			object.zadd(set_name, timestamp, 'payload')
		end
		
		it "can generate correct arguments with options" do
			expect(object).to receive(:call).with('ZADD', set_name, 'XX', 'CH', 'INCR', timestamp, 'payload')
			
			object.zadd(set_name, timestamp, 'payload', update: true, change: true, increment: true)
		end
		
		it "can generate correct multiple arguments" do
			expect(object).to receive(:call).with('ZADD', set_name, 'XX', 'CH', 'INCR', timestamp, 'payload-1', timestamp, 'payload-2')
			
			object.zadd(set_name, timestamp, 'payload-1', timestamp, 'payload-2', update: true, change: true, increment: true)
		end
	end
	
	with '#zrange' do
		it "can generate correct arguments" do
			expect(object).to receive(:call).with('ZRANGE', set_name, 0, 0)
			
			object.zrange(set_name, 0, 0)
		end
		
		it "can generate correct arguments with options" do
			expect(object).to receive(:call).with('ZRANGE', set_name, 0, 0, 'WITHSCORES')
			
			object.zrange(set_name, 0, 0, with_scores: true)
		end
	end
	
	with '#zrangebyscore' do
		it "can generate correct arguments" do
			expect(object).to receive(:call).with('ZRANGEBYSCORE', set_name, 0, 0)
			
			object.zrangebyscore(set_name, 0, 0)
		end
		
		it "can generate correct arguments with WITHSCORES options" do
			expect(object).to receive(:call).with('ZRANGEBYSCORE', set_name, 0, 0, 'WITHSCORES')
			
			object.zrangebyscore(set_name, 0, 0, with_scores: true)
		end
		
		it "can generate correct arguments with WITHSCORES options" do
			expect(object).to receive(:call).with('ZRANGEBYSCORE', set_name, 0, 0, 'WITHSCORES', 'LIMIT', 0, 10)
			
			object.zrangebyscore(set_name, 0, 0, with_scores: true, limit: [0, 10])
		end
	end
	
	with '#zrem' do
		let(:member_name) { 'test_member' }
		
		it "can generate correct arguments" do
			expect(object).to receive(:call).with('ZREM', set_name, member_name)
			
			object.zrem(set_name, member_name)
		end
	end
end
