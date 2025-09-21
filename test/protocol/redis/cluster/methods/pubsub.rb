# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2025, by Samuel Williams.

require "protocol/redis/cluster/methods/pubsub"
require "protocol/redis/cluster/methods_context"

describe Protocol::Redis::Cluster::Methods::Pubsub do
	include_context Protocol::Redis::Cluster::MethodsContext, Protocol::Redis::Cluster::Methods::Pubsub
	
	let(:channel) {"test_channel"}
	let(:message) {"Hello, World!"}
	let(:pattern) {"test_*"}
	
	with "#publish" do
		it "can publish a message to a channel using sharded publish" do
			expect(object).to receive(:call).with("SPUBLISH", channel, message).and_return(1)
			
			expect(object.publish(channel, message)).to be == 1
		end
	end
end
