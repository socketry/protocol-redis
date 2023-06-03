# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2023, by Samuel Williams.

require 'methods_context'
require 'protocol/redis/methods/hashes'

describe Protocol::Redis::Methods::Hashes do
	include_context MethodsContext, Protocol::Redis::Methods::Hashes
	
	let(:hash_name) {'htest'}
	let(:field_name) {'field'}
	let(:value) {'value'}

	with '#hsetnx' do
		it 'can generate correct arguments' do
			expect(object).to receive(:call).with('HSETNX', hash_name, field_name, value).and_return(1)

			expect(object.hsetnx(hash_name, field_name, value)).to be == true
		end
	end

	with '#hexists' do
		it 'can generate correct arguments' do
			expect(object).to receive(:call).with('HEXISTS', hash_name, field_name).and_return(1)

			expect(object.hexists(hash_name, field_name)).to be == true
		end
	end

	with '#hincrbyfloat' do
		let(:value) { 3.14 }

		it 'can generate correct arguments' do
			expect(object).to receive(:call).with('HINCRBYFLOAT', hash_name, field_name, value).and_return('3.1400000000000001')

			expect(object.hincrbyfloat(hash_name, field_name, value)).to be ==  value
		end
	end

	with '#hgetall' do
		it 'can generate correct arguments' do
			expect(object).to receive(:call).with('HGETALL', hash_name).and_return([field_name, value, 'test', '1'])

			expect(object.hgetall(hash_name)).to be == {field_name => value, 'test' => '1'}
		end
	end
end
