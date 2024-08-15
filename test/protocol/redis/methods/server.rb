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
	
	describe '#client_info' do
		let(:example_client_info_response) do
			"id=267 addr=[::1]:62359 laddr=[::1]:6379 fd=8 name= age=0 idle=0 flags=N db=1 sub=0 psub=0 ssub=0 multi=-1 qbuf=26 qbuf-free=20448 argv-mem=10 multi-mem=0 rbs=16384 rbp=16384 obl=0 oll=0 omem=0 tot-mem=37786 events=r cmd=client|info user=default redir=-1 resp=2 lib-name= lib-ver="
		end
		
		it 'can generate correct arguments' do
			expect(object).to receive(:call).with('CLIENT', 'INFO').and_return(example_client_info_response)
			
			response = object.client_info
			expect(response).to have_keys(
				id: be == '267',
				addr: be == '[::1]:62359',
				laddr: be == '[::1]:6379',
				fd: be == '8',
				name: be_nil,
				age: be == '0',
				idle: be == '0',
				flags: be == 'N',
				db: be == '1',
				sub: be == '0',
				psub: be == '0',
				ssub: be == '0',
				multi: be == '-1',
				qbuf: be == '26',
				'lib-name': be_nil,
				'lib-ver': be_nil,
			)
		end
	end
end
