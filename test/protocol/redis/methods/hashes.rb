# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2023, by Samuel Williams.
# Copyright, 2023, by Nick Burwell.

require 'methods_context'
require 'protocol/redis/methods/hashes'

describe Protocol::Redis::Methods::Hashes do
	include_context MethodsContext, Protocol::Redis::Methods::Hashes
	
	let(:hash_name) {'htest'}
	let(:field_name) {'field'}
	let(:field2_name) {'field2'}
	let(:value) {'value'}
	let(:value2) {'value2'}

	with '#hsetnx' do
		it 'can generate correct arguments' do
			expect(object).to receive(:call).with('HSETNX', hash_name, field_name, value).and_return(1)

			expect(object.hsetnx(hash_name, field_name, value)).to be == true
		end
	end

	with '#hmset' do
		it 'can generate correct arguments' do
			expect(object).to receive(:call).with('HMSET', hash_name, field_name, value).and_return("OK")

			expect(object.hmset(hash_name, field_name, value)).to be == "OK"
		end
	end

	with '#mapped_hmset' do
		it 'can generate correct arguments from a hash' do
			expect(object).to receive(:call).with('HMSET', hash_name, field_name, value).and_return("OK")

			expect(object.mapped_hmset(hash_name, { field_name => value })).to be == "OK"
		end
	end

	with '#hget' do
		it 'can generate correct arguments' do
			expect(object).to receive(:call).with('HGET', hash_name, field_name).and_return(value)

			expect(object.hget(hash_name, field_name)).to be == value
		end
	end

	with '#hmget' do
		it 'can generate correct arguments' do
			expect(object).to receive(:call).with('HMGET', hash_name, field_name, field2_name).and_return([value, value2])

			expect(object.hmget(hash_name, field_name, field2_name)).to be == [value, value2]
		end
	end

	with '#mapped_hmget' do
		it 'can generate correct arguments and return hash' do
			expect(object).to receive(:call).with('HMGET', hash_name, field_name, field2_name).and_return([value, value2])

			expect(object.mapped_hmget(hash_name, field_name, field2_name)).to be == {
				field_name => value,
				field2_name => value2
			}
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

			expect(object.hincrbyfloat(hash_name, field_name, value)).to be == value
		end
	end

	with '#hgetall' do
		it 'can generate correct arguments' do
			expect(object).to receive(:call).with('HGETALL', hash_name).and_return([field_name, value, 'test', '1'])

			expect(object.hgetall(hash_name)).to be == {field_name => value, 'test' => '1'}
		end
	end
	
	with '#hscan' do
		it 'can generate correct arguments' do
			expect(object).to receive(:call).with('HSCAN', hash_name, 0).and_return([0, []])

			expect(object.hscan(hash_name, 0)).to be == [0, []]
		end
	end
end
