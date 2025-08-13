# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2020-2023, by Samuel Williams.

require "protocol/redis/methods_context"
require "protocol/redis/methods/pubsub"

describe Protocol::Redis::Methods::Pubsub do
	include_context Protocol::Redis::MethodsContext, Protocol::Redis::Methods::Pubsub
	
	let(:channel) {"test_channel"}
	let(:message) {"Hello, World!"}
	
	with "#publish" do
		it "can generate correct arguments" do
			expect(object).to receive(:call).with("PUBLISH", channel, message).and_return(1)
			
			expect(object.publish(channel, message)).to be == 1
		end
	end
end
