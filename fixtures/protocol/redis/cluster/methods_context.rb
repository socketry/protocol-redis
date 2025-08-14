# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2023, by Samuel Williams.

require "protocol/redis/connection"
require "socket"

module Protocol
	module Redis
		module Cluster
			class MockCluster
				def call(*arguments)
				end
				
				def slot_for(key)
					return 0
				end
				
				def slots_for(keys)
					if keys.any?
						return {0 => keys}
					else
						return {}
					end
				end
				
				def client_for(slot, role = :master)
					return self
				end
				
				def clients_for(*keys, role: :master, attempts: 3)
					slots = slots_for(keys)
					
					slots.each do |slot, keys|
						yield client_for(slot, role), keys
					end
				end
				
				def any_client(role = :master)
					return self
				end
			end
			
			MethodsContext = Sus::Shared("a methods object") do |*modules|
				def class_including(*modules)
					subclass = Class.new(MockCluster)
					subclass.include(*modules)
					return subclass
				end
				
				let(:object) {class_including(*modules).new}
			end
		end
	end
end
