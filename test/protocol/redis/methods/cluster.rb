# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2023, by Nick Burwell.
# Copyright, 2023, by Samuel Williams.

require 'methods_context'
require 'protocol/redis/methods/cluster'

describe Protocol::Redis::Methods::Cluster do
  include_context MethodsContext, Protocol::Redis::Methods::Cluster

  describe '#cluster' do
    it "can generate correct arguments" do
      expect(object).to receive(:call).with("CLUSTER", "info")

      object.cluster(:info)
    end

    it "can generate correct arguments with multiple arguments" do
      expect(object).to receive(:call).with("CLUSTER", "addslots", 'slot1')

      object.cluster(:addslots, 'slot1')
    end
  end

  describe '#asking' do
    it "can generate correct call with no arguments" do
      expect(object).to receive(:call).with("ASKING")

      object.asking
    end
  end
end
