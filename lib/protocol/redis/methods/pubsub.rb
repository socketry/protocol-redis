# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2020-2023, by Samuel Williams.

module Protocol
	module Redis
		module Methods
			module Pubsub
				# Post a message to a channel.
				# @see https://redis.io/commands/publish
				# @param channel [String]
				# @param message [String]
				def publish(channel, message)
					call('PUBLISH', channel, message)
				end
			end
		end
	end
end
