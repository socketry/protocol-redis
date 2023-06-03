# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2020, by David Ortiz.
# Copyright, 2023, by Samuel Williams.

require 'methods_context'
require 'protocol/redis/methods/server'

describe Protocol::Redis::Methods::Server do
	include_context MethodsContext, Protocol::Redis::Methods::Server

	describe '#info' do
		# This is an incomplete response but contains all we need for the test
		let(:example_info_response) do
			"# Server\r\nredis_version:5.0.7\r\nprocess_id:123\r\n"
		end

		it 'can generate correct arguments' do
			expect(object).to receive(:call).with('INFO').and_return(example_info_response)

			response = object.info
			expect(response[:redis_version]).to be == '5.0.7'
			expect(response[:process_id]).to be == '123'
		end
	end
end
