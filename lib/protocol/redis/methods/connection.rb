# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2019-2023, by Samuel Williams.

module Protocol
	module Redis
		module Methods
			module Connection
				# Authenticate to the server.
				# @see https://redis.io/commands/auth
				# @param username [String] Optional username, if Redis ACLs are used.
				# @param password [String] Required password.
				def auth(*arguments)
					call("AUTH", *arguments)
				end
				
				# Echo the given string.
				# @see https://redis.io/commands/echo
				# @param message [String]
				def echo(message)
					call("ECHO", message)
				end
				
				# Ping the server.
				# @see https://redis.io/commands/ping
				# @param message [String]
				def ping(message)
					call("PING", message)
				end
				
				# Close the connection.
				# @see https://redis.io/commands/quit
				def quit
					call("QUIT")
				end
			end
		end
	end
end
