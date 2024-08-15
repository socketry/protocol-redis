# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2019-2023, by Samuel Williams.

require 'protocol/redis/connection'
require 'connection_context'

describe Protocol::Redis::Connection do
	include_context ConnectionContext
	
	with '#write_object' do
		it "can write strings" do
			client.write_object("Hello World!")
			
			expect(server.read_object).to be == "Hello World!"
		end
	end
end
