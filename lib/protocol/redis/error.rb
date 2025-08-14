# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2019-2023, by Samuel Williams.

module Protocol
	module Redis
		# Represents a general Redis protocol error.
		class Error < StandardError
		end
		
		# Represents an error response from the Redis server.
		class ServerError < Error
		end
		
		# Represents an unknown token error in the Redis protocol.
		class UnknownTokenError < Error
		end
	end
end
