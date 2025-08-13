# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2019-2024, by Samuel Williams.

require "protocol/redis/connection"
require "protocol/redis/connection_context"

describe Protocol::Redis::Connection do
	include_context Protocol::Redis::ConnectionContext
	
	with "#write_object" do
		it "can write strings" do
			client.write_object("Hello World!")
			
			expect(server.read_object).to be == "Hello World!"
		end
	end
	
	with "#close" do
		it "can close the connection" do
			client.close
			
			expect(client.closed?).to be == true
		end
	end
end
