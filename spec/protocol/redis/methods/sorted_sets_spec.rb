# Copyright, 2019, by Samuel G. D. Williams. <http://www.codeotaku.com>
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

require_relative 'helper'

require 'protocol/redis/methods/sorted_sets'

RSpec.describe Protocol::Redis::Methods::SortedSets do
	let(:object) { Object.including(Protocol::Redis::Methods::SortedSets).new }
  let(:set_name) { 'test' }
	
	describe '#zadd' do
		let(:timestamp) { Time.now.to_f }

		it "can generate correct arguments" do
			expect(object).to receive(:call).with('ZADD', set_name, timestamp, 'payload')
			
			object.zadd(set_name, timestamp, 'payload')
		end

		it "can generate correct arguments with options" do
			expect(object).to receive(:call).with('ZADD', set_name, 'XX', 'CH', 'INCR', timestamp, 'payload')
			
			object.zadd(set_name, timestamp, 'payload', xx: true, ch: true, incr: true)
		end

		it "can generate correct multiple arguments" do
			expect(object).to receive(:call)
			                    .with('ZADD', set_name, 'XX', 'CH', 'INCR', timestamp, 'payload-1', timestamp, 'payload-2')
			
			object.zadd(set_name, [[timestamp, 'payload-1'], [timestamp, 'payload-2']], xx: true, ch: true, incr: true)
		end
	end

	describe '#zrange' do
		it "can generate correct arguments" do
			expect(object).to receive(:call).with('ZRANGE', set_name, 0, 0)
			
			object.zrange(set_name, 0, 0)
		end

		it "can generate correct arguments with options" do
			expect(object).to receive(:call).with('ZRANGE', set_name, 0, 0, 'WITHSCORES')
			
			object.zrange(set_name, 0, 0, withscores: true)
		end
	end

	describe '#zrem' do
		let(:member_name) { 'test_member' }
		
		it "can generate correct arguments" do
			expect(object).to receive(:call).with('ZREM', set_name, member_name)
			
			object.zrem(set_name, member_name)
		end
	end
end