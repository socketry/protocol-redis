# frozen_string_literal: true

module Protocol
	module Redis
		module Cluster
			module Methods
				# Provides Redis Pub/Sub commands for cluster environments.
				# Uses sharded pub/sub by default for optimal cluster performance.
				module Pubsub
					# Post a message to a channel using cluster-optimized sharded publish.
					# Routes the message directly to the appropriate shard based on the channel name.
					# @parameter channel [String] The channel name.
					# @parameter message [String] The message to publish.
					# @parameter role [Symbol] The role of node to use (`:master` or `:slave`).
					# @returns [Integer] The number of clients that received the message.
					def publish(channel, message, role: :master)
						# Route to the correct shard based on channel name:
						slot = slot_for(channel)
						client = client_for(slot, role)
						
						return client.call("SPUBLISH", channel, message)
					end
				end
			end
		end
	end
end
