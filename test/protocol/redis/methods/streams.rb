# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2020, by Nakul Warrier.
# Copyright, 2023, by Samuel Williams.

require 'methods_context'
require 'protocol/redis/methods/streams'

describe Protocol::Redis::Methods::Streams do
	include_context MethodsContext, Protocol::Redis::Methods::Streams

	describe '#xinfo' do
		let(:stream) {"STREAM"}
		let(:key) {"mystream"}

		it "can generate correct arguments" do
			expect(object).to receive(:call).with("XINFO", stream, key)

			object.xinfo(stream, key)
		end
	end

  describe '#xadd' do
		let(:key_name) {"mykey"}
		let(:key) {"name"}
    let(:value) {"sara"}

		it "can generate correct arguments" do
			expect(object).to receive(:call).with("XADD", key_name, key, value)

			object.xadd(key_name, key, value)
		end
	end

  describe '#xtrim' do
		let(:key_name) {"mykey"}
    let(:value) {1000}

		it "can generate correct arguments" do
			expect(object).to receive(:call).with("XTRIM", key_name, "MAXLEN", value)

			object.xtrim(key_name, "MAXLEN", value)
		end
	end

  describe '#xdel' do
		let(:key_name) {"mykey"}
		let(:id) {"1000001234-0"}

		it "can generate correct arguments" do
			expect(object).to receive(:call).with("XDEL", key_name, id)

			object.xdel(key_name, id)
		end
	end

  describe '#xrange' do
		let(:key_name) {"mykey"}
		let(:id) {"1000001234-0"}
    let(:count_value) {"1"}

		it "can generate correct arguments" do
			expect(object).to receive(:call).with("XRANGE", key_name, id,"+ COUNT", count_value)

			object.xrange(key_name, id,"+ COUNT", count_value)
		end
	end

  describe '#xrevrange' do
		let(:key_name) {"mykey"}
		let(:id) {"1000001234-0"}
    let(:count_value) {"1"}

		it "can generate correct arguments" do
			expect(object).to receive(:call).with("XREVRANGE", key_name, id,"+ COUNT", count_value)

			object.xrevrange(key_name, id,"+ COUNT", count_value)
		end
	end

  describe '#xlen' do
		let(:key) {"mystream"}

		it "can generate correct arguments" do
			expect(object).to receive(:call).with("XLEN", key)

			object.xlen(key)
		end
	end

  describe '#xread' do
		let(:key_name) {"mykey"}
		let(:id) {"1000001234-0"}
    let(:count_value) {"1"}

		it "can generate correct arguments" do
			expect(object).to receive(:call).with("XREAD", "+ COUNT", count_value, "STREAMS", key_name, "writers", id)

			object.xread("+ COUNT", count_value, "STREAMS", key_name, "writers", id)
		end
	end

  describe '#xgroup' do
		let(:key_name) {"mykey"}
    let(:group_name) {"mygroup"}

		it "can generate correct arguments" do
			expect(object).to receive(:call).with("XGROUP", "CREATE", key_name, group_name, "$")

			object.xgroup("CREATE", key_name, group_name, "$")
		end
	end

  describe '#xreadgroup' do
		let(:key_name) {"mykey"}
		let(:id) {"1000001234-0"}
    let(:count_value) {"1"}
    let(:group_name) {"mygroup"}
    let(:consumer_name) {"myconsumer"}

		it "can generate correct arguments" do
			expect(object).to receive(:call).with("XREADGROUP", "GROUP", group_name, consumer_name, "+ COUNT", count_value, "STREAMS", key_name, "writers", id)

			object.xreadgroup("GROUP", group_name, consumer_name, "+ COUNT", count_value, "STREAMS", key_name, "writers", id)
		end
	end

  describe '#xack' do
		let(:key_name) {"mykey"}
		let(:group_name) {"mygroup"}
    let(:id) {"1000001234-0"}

		it "can generate correct arguments" do
			expect(object).to receive(:call).with("XACK", key_name, group_name, id)

			object.xack(key_name, group_name, id)
		end
	end

  describe '#xclaim' do
		let(:key_name) {"mykey"}
		let(:id) {"1000001234-0"}
    let(:min_idle_time) {"360000"}
    let(:group_name) {"mygroup"}
    let(:consumer_name) {"myconsumer"}

		it "can generate correct arguments" do
			expect(object).to receive(:call).with("XCLAIM", key_name, group_name, consumer_name, min_idle_time, id)

			object.xclaim(key_name, group_name, consumer_name, min_idle_time, id)
		end
	end

  describe '#xpending' do
		let(:key_name) {"mykey"}
    let(:group_name) {"mygroup"}

		it "can generate correct arguments" do
			expect(object).to receive(:call).with("XPENDING", key_name, group_name)

			object.xpending(key_name, group_name)
		end
	end
end
