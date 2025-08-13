# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2019-2024, by Samuel Williams.
# Copyright, 2020, by David Ortiz.

module Protocol
	module Redis
		module Methods
			# Methods for managing Redis servers.
			module Server
				# Get information and statistics about the server.
				# See <https://redis.io/commands/info> for more details.
				# @parameter section [String]
				def info
					metadata = {}
					
					call("INFO").each_line(Redis::Connection::CRLF) do |line|
						key, value = line.split(":")
						
						if value
							metadata[key.to_sym] = value.chomp!
						end
					end
					
					return metadata
				end
				
				def client_info
					metadata = {}
					
					call("CLIENT", "INFO").split(/\s+/).each do |pair|
						key, value = pair.split("=")
						
						if value
							metadata[key.to_sym] = value
						else
							metadata[key.to_sym] = nil
						end
					end
					
					return metadata
				end
				
				# Remove all keys from the current database.
				# See <https://redis.io/commands/flushdb> for more details.
				# @parameter async [Enum]
				def flushdb!
					call("FLUSHDB")
				end
			end
		end
	end
end
