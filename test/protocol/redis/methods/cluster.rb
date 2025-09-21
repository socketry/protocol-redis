# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2023, by Nick Burwell.
# Copyright, 2024-2025, by Samuel Williams.

require "protocol/redis/methods_context"
require "protocol/redis/methods/cluster"

describe Protocol::Redis::Methods::Cluster do
	include_context Protocol::Redis::MethodsContext, Protocol::Redis::Methods::Cluster
	
	with "#cluster" do
		it "can generate correct arguments" do
			expect(object).to receive(:call).with("CLUSTER", "info")
			
			object.cluster(:info)
		end
		
		it "can generate correct arguments with multiple arguments" do
			expect(object).to receive(:call).with("CLUSTER", "addslots", "slot1")
			
			object.cluster(:addslots, "slot1")
		end
	end
	
	with "#asking" do
		it "can generate correct call with no arguments" do
			expect(object).to receive(:call).with("ASKING")
			
			object.asking
		end
	end
end
