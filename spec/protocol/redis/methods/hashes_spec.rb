# frozen_string_literal: true

# Copyright, 2019, by Samuel G. D. Williams. <http://www.codeotaku.com>
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the 'Software'), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

require_relative 'helper'

require 'protocol/redis/methods/hashes'

RSpec.describe Protocol::Redis::Methods::Hashes do
	let(:object) {Object.including(described_class).new}
	let(:hash_name) { 'htest' }
	let(:field_name) { 'field' }
	let(:value) { 'value' }

	describe '#hsetnx' do
		it 'can generate correct arguments' do
			expect(object).to receive(:call).with('HSETNX', hash_name, field_name, value).and_return(1)

			expect(object.hsetnx(hash_name, field_name, value)).to be true
		end
	end

	describe '#hexists' do
		it 'can generate correct arguments' do
			expect(object).to receive(:call).with('HEXISTS', hash_name, field_name).and_return(1)

			expect(object.hexists(hash_name, field_name)).to be true
		end
	end

	describe '#hincrbyfloat' do
		let(:value) { 3.14 }

		it 'can generate correct arguments' do
			expect(object).to receive(:call).with('HINCRBYFLOAT', hash_name, field_name, value).and_return('3.1400000000000001')

			expect(object.hincrbyfloat(hash_name, field_name, value)).to eq value
		end
	end

	describe '#hgetall' do
		it 'can generate correct arguments' do
			expect(object).to receive(:call).with('HGETALL', hash_name).and_return([field_name, value, 'test', '1'])

			expect(object.hgetall(hash_name)).to eq({ field_name => value, 'test' => '1' })
		end
	end
end
