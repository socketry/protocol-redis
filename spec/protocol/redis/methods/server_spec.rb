require_relative 'helper'

require 'protocol/redis/methods/server'

RSpec.describe Protocol::Redis::Methods::Server do
	let(:object) {Object.including(Protocol::Redis::Methods::Server).new}

	describe '#info' do
		# This is an incomplete response but contains all we need for the test
		let(:example_info_response) do
			"# Server\r\nredis_version:5.0.7\r\nprocess_id:123\r\n"
		end

		it 'can generate correct arguments' do
			expect(object).to receive(:call).with('INFO').and_return(example_info_response)

			response = object.info
			expect(response[:redis_version]).to eq '5.0.7'
			expect(response[:process_id]).to eq '123'
		end
	end
end
