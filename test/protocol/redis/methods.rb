# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2019-2025, by Samuel Williams.
# Copyright, 2021, by Daniel Evans.

require "protocol/redis/methods"

describe Protocol::Redis::Methods do
	with "included module" do
		let(:constants) do
			subject.constants(false).map do |name|
				subject.const_get(name)
			end
		end
		
		it "includes all other methods modules" do
			klass = Class.new
			klass.include(subject)
			
			constants.each do |mod|
				expect(klass.ancestors).to be(:include?, mod)
			end
		end
	end
end
