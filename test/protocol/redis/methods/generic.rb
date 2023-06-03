# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2023, by Samuel Williams.

require 'methods_context'
require 'protocol/redis/methods/generic'

describe Protocol::Redis::Methods::Generic do
	include_context MethodsContext, Protocol::Redis::Methods::Generic

	describe '#exists?' do
		let(:key_1) {"mykey"}
		let(:key_2) {"yourkey"}

		it "can generate correct arguments" do
			expect(object).to receive(:exists).with(key_1, key_2).and_return(1)

			expect(object.exists?(key_1, key_2)).to be == true
		end
	end
end
