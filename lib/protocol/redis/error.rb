# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2019-2023, by Samuel Williams.

module Protocol
	module Redis
		class Error < StandardError
		end
		
		class ServerError < Error
		end
	end
end
