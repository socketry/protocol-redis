# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2025, by Samuel Williams.

require_relative "methods/generic"
require_relative "methods/pubsub"

module Protocol
	module Redis
		module Cluster
			# A collection of methods for interacting with Redis.
			module Methods
				# Includes all Redis methods into the given class.
				def self.included(klass)
					klass.include Methods::Generic
					klass.include Methods::Pubsub
				end
			end
		end
	end
end
