# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2019-2025, by Samuel Williams.

module Protocol
	module Redis
		module Methods
			# Methods for managing Redis connections.
			module Connection
				# Authenticate to the server.
				# See <https://redis.io/commands/auth> for more details.
				# @parameter username [String] Optional username, if Redis ACLs are used.
				# @parameter password [String] Required password.
				def auth(*arguments)
					call("AUTH", *arguments)
				end
				
				# Echo the given string.
				# See <https://redis.io/commands/echo> for more details.
				# @parameter message [String]
				def echo(message)
					call("ECHO", message)
				end
				
				# Ping the server.
				# See <https://redis.io/commands/ping> for more details.
				# @parameter message [String]
				def ping(message)
					call("PING", message)
				end
				
				# Close the connection.
				# See <https://redis.io/commands/quit> for more details.
				def quit
					call("QUIT")
				end
			end
		end
	end
end
