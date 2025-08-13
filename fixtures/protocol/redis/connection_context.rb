# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2019-2024, by Samuel Williams.

require "protocol/redis/connection"
require "socket"

module Protocol
	module Redis
		ConnectionContext = Sus::Shared("a connection") do
			let(:sockets) {Socket.pair(Socket::PF_UNIX, Socket::SOCK_STREAM)}
			
			let(:client) {Protocol::Redis::Connection.new(sockets.first)}
			let(:server) {Protocol::Redis::Connection.new(sockets.last)}
		end
	end
end
