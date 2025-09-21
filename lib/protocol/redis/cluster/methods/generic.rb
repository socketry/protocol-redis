# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2025, by Samuel Williams.

module Protocol
	module Redis
		module Cluster
			module Methods
				# Provides generic Redis commands for cluster environments.
				# These methods distribute operations across cluster nodes based on key slots.
				module Generic
					# Delete one or more keys from the cluster.
					# Uses the appropriate client(s) for each key's slot.
					# @parameter keys [Array(String)] The keys to delete.
					# @parameter role [Symbol] The role of node to use (`:master` or `:slave`).
					# @parameter options [Hash] Additional options passed to the client.
					# @returns [Integer] The number of keys deleted.
					def del(*keys, role: :master, **options)
						return 0 if keys.empty?
						
						count = 0
						
						clients_for(*keys, role: role) do |client, grouped_keys|
							count += client.call("DEL", *grouped_keys)
						end
						
						return count
					end
					
					# Check existence of one or more keys in the cluster.
					# @parameter keys [Array(String)] The keys to check.
					# @parameter role [Symbol] The role of node to use (`:master` or `:slave`).
					# @parameter options [Hash] Additional options passed to the client.
					# @returns [Integer] The number of keys existing.
					def exists(*keys, role: :master, **options)
						return 0 if keys.empty?
						
						count = 0
						
						clients_for(*keys, role: role) do |client, grouped_keys|
							count += client.call("EXISTS", *grouped_keys)
						end
						
						return count
					end
					
					# Get the values of multiple keys from the cluster.
					# @parameter keys [Array(String)] The keys to fetch.
					# @parameter role [Symbol] The role of node to use (`:master` or `:slave`).
					# @parameter options [Hash] Additional options passed to the client.
					# @returns [Array] The values for the given keys, in order.
					def mget(*keys, role: :master, **options)
						return [] if keys.empty?
						
						results = Array.new(keys.size)
						key_to_index = keys.each_with_index.to_h
						
						clients_for(*keys, role: role) do |client, grouped_keys|
							values = client.call("MGET", *grouped_keys)
							grouped_keys.each_with_index do |key, i|
								results[key_to_index[key]] = values[i]
							end
						end
						
						return results
					end
					
					# Get the value of a single key from the cluster.
					# @parameter key [String] The key to fetch.
					# @parameter role [Symbol] The role of node to use (`:master` or `:slave`).
					# @parameter options [Hash] Additional options passed to the client.
					# @returns [Object] The value for the given key.
					def get(key, role: :master, **options)
						slot = slot_for(key)
						client = client_for(slot, role)
						
						return client.call("GET", key)
					end
					
					# Set the value of a single key in the cluster.
					# @parameter key [String] The key to set.
					# @parameter value [Object] The value to set.
					# @parameter role [Symbol] The role of node to use (`:master` or `:slave`).
					# @parameter options [Hash] Additional options passed to the client.
					# @returns [String | Boolean] Status reply or `true`/`false` depending on client implementation.
					def set(key, value, role: :master, **options)
						slot = slot_for(key)
						client = client_for(slot, role)
						
						return client.call("SET", key, value)
					end
				end
			end
		end
	end
end
