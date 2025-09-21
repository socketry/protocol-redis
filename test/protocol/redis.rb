# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2019-2025, by Samuel Williams.

require "protocol/redis/version"

describe Protocol::Redis do
	it "has a version number" do
		expect(Protocol::Redis::VERSION).to be =~ /\d+\.\d+\.\d+/
	end
end
