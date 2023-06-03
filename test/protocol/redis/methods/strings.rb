# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2019-2023, by Samuel Williams.
# Copyright, 2020, by Nakul Warrier.

require 'methods_context'
require 'protocol/redis/methods/strings'

describe Protocol::Redis::Methods::Strings do
	include_context MethodsContext, Protocol::Redis::Methods::Strings
	
	describe '#append' do
		let(:key) {"mykey"}
		let(:value) {"UpdatedValue"}
		
		it "can generate correct arguments" do
			expect(object).to receive(:call).with("APPEND", key, value)
			
			object.append(key, value)
		end
	end

	describe '#bitcount' do
		let(:key) {"mykey"}
		
		it "can generate correct arguments" do
			expect(object).to receive(:call).with("BITCOUNT", key, 0, 0)
			
			object.bitcount(key, 0, 0)
		end
	end
	
	describe '#decr' do
		let(:key) {"mykey"}

		it "can generate correct arguments" do
			expect(object).to receive(:call).with("DECR", key)
			
			object.decr(key)
		end
	end

	describe '#decrby' do
		let(:key) {"mykey"}
		let(:decrement) {4}
		
		it "can generate correct arguments" do
			expect(object).to receive(:call).with("DECRBY", key, decrement)
			
			object.decrby(key, decrement)
		end
	end

	describe '#get' do
		let(:key) {"mykey"}
		
		it "can generate correct arguments" do
			expect(object).to receive(:call).with("GET", key)
			
			object.get(key)
		end
	end
	
	describe '#getbit' do
		let(:key) {"mykey"}
		let(:offset) {4}
		
		it "can generate correct arguments" do
			expect(object).to receive(:call).with("GETBIT", key, offset)
			
			object.getbit(key, offset)
		end
	end
	
	describe '#getrange' do
		let(:key) {"mykey"}
		let(:start_index) {0}
		let(:end_index) {3}
		
		it "can generate correct arguments" do
			expect(object).to receive(:call).with("GETRANGE", key, start_index, end_index)
			
			object.getrange(key, start_index, end_index)
		end
	end
	
	describe '#getset' do
		let(:key) {"mykey"}
		let(:value) {"newkey"}
		
		it "can generate correct arguments" do
			expect(object).to receive(:call).with("GETSET", key, value)
			
			object.getset(key, value)
		end
	end
	
	describe '#incr' do
		let(:key) {"mykey"}
		
		it "can generate correct arguments" do
			expect(object).to receive(:call).with("INCR", key)
			
			object.incr(key)
		end
	end
	
	describe '#incrby' do
		let(:key) {"mykey"}
		let(:increment) {3}
		
		it "can generate correct arguments" do
			expect(object).to receive(:call).with("INCRBY", key, increment)
			
			object.incrby(key, increment)
		end
	end
	
	describe '#incrbyfloat' do
		let(:key) {"mykey"}
		let(:increment) {3.5}
		
		it "can generate correct arguments" do
			expect(object).to receive(:call).with("INCRBYFLOAT", key, increment)
			
			object.incrbyfloat(key, increment)
		end
	end
	
	describe '#mget' do
		let(:key1) {"mykey1"}
		let(:key2) {"mykey2"}
		
		it "can generate correct arguments" do
			expect(object).to receive(:call).with("MGET", key1, key2)
			
			object.mget(key1, key2)
		end
	end
	
	describe '#mset' do
		let(:pairs) {{"mykey1" => "myvalue1", "mykey2" => "myvalue2"}}
		
		it "can generate correct arguments" do
			expect(object).to receive(:call).with("MSET", "mykey1", "myvalue1", "mykey2", "myvalue2")
			
			object.mset(pairs)
		end
	end
	
	describe '#msetnx' do
		let(:pairs) {{"mykey1" => "myvalue1", "mykey2" => "myvalue2"}}
		
		it "can generate correct arguments" do
			expect(object).to receive(:call).with("MSETNX", "mykey1", "myvalue1", "mykey2", "myvalue2")
			
			object.msetnx(pairs)
		end
	end
	
	describe '#psetex' do
		let(:key) {"mykey"}
		let(:milliseconds) {1000}
		let(:value) {"myvalue"}
		
		it "can generate correct arguments" do
			expect(object).to receive(:call).with("PSETEX", key, milliseconds, value)
			
			object.psetex(key, milliseconds, value)
		end
	end
	
	describe '#set' do
		let(:key) {"mykey"}
		let(:value) {"newkey"}
		
		it "can generate correct arguments" do
			expect(object).to receive(:call).with("SET", key, value)
			
			object.set(key, value)
		end
		
		it "can generate correct arguments with SECONDS EXPIRY and KEY EXISTS options" do
			expect(object).to receive(:call).with("SET", key, value, 'EX', 60, 'XX')
			
			object.set(key, value, update: true, seconds: 60)
		end
		
		it "can generate correct arguments with MILLISECONDS EXPIRY and KEY NOT EXISTS options" do
			expect(object).to receive(:call).with("SET", key, value, 'PX', 60, 'NX')
			
			object.set(key, value, update: false, milliseconds: 60)
		end
	end
	
	describe '#setbit' do
		let(:key) {"mykey"}
		let(:offset) {2}
		let(:value) {"myvalue"}
		
		it "can generate correct arguments" do
			expect(object).to receive(:call).with("SETBIT", key, offset, value)
			
			object.setbit(key, offset, value)
		end
	end
	
	describe '#setex' do
		let(:key) {"mykey"}
		let(:seconds) {2}
		let(:value) {"myvalue"}
		
		it "can generate correct arguments" do
			expect(object).to receive(:call).with("SETEX", key, seconds, value)
			
			object.setex(key, seconds, value)
		end
	end
	
	describe '#setnx' do
		let(:key) {"mykey"}
		let(:value) {"myvalue"}
		
		it "can generate correct arguments" do
			expect(object).to receive(:call).with("SETNX", key, value)
			
			object.setnx(key, value)
		end
	end
	
	describe '#setrange' do
		let(:key) {"mykey"}
		let(:offset) {2}
		let(:value) {"myvalue"}
		
		it "can generate correct arguments" do
			expect(object).to receive(:call).with("SETRANGE", key, offset, value)
			
			object.setrange(key, offset, value)
		end
	end
	
	describe '#strlen' do
		let(:key) {"mykey"}
		
		it "can generate correct arguments" do
			expect(object).to receive(:call).with("STRLEN", key)
			
			object.strlen(key)
		end
	end
end
