# frozen_string_literal: true

module Protocol
	module Redis
		module Cluster
			module Methods
				# Provides Redis String commands for cluster environments.
				# String operations are routed to the appropriate shard based on the key.
				module Strings
					# Append a value to a key.
					# @parameter key [String] The key to append to.
					# @parameter value [String] The value to append.
					# @parameter role [Symbol] The role of node to use (`:master` or `:slave`).
					# @returns [Integer] The length of the string after the append operation.
					def append(key, value, role: :master)
						slot = slot_for(key)
						client = client_for(slot, role)
						
						return client.call("APPEND", key, value)
					end
					
					# Count set bits in a string.
					# @parameter key [String] The key to count bits in.
					# @parameter range [Array] Optional start and end positions.
					# @parameter role [Symbol] The role of node to use (`:master` or `:slave`).
					# @returns [Integer] The number of set bits.
					def bitcount(key, *range, role: :master)
						slot = slot_for(key)
						client = client_for(slot, role)
						
						return client.call("BITCOUNT", key, *range)
					end
					
					# Decrement the integer value of a key by one.
					# @parameter key [String] The key to decrement.
					# @parameter role [Symbol] The role of node to use (`:master` or `:slave`).
					# @returns [Integer] The value after decrementing.
					def decr(key, role: :master)
						slot = slot_for(key)
						client = client_for(slot, role)
						
						return client.call("DECR", key)
					end
					
					# Decrement the integer value of a key by the given number.
					# @parameter key [String] The key to decrement.
					# @parameter decrement [Integer] The amount to decrement by.
					# @parameter role [Symbol] The role of node to use (`:master` or `:slave`).
					# @returns [Integer] The value after decrementing.
					def decrby(key, decrement, role: :master)
						slot = slot_for(key)
						client = client_for(slot, role)
						
						return client.call("DECRBY", key, decrement)
					end
					
					# Get the value of a key.
					# @parameter key [String] The key to get.
					# @parameter role [Symbol] The role of node to use (`:master` or `:slave`).
					# @returns [String | nil] The value, or `nil` if key doesn't exist.
					def get(key, role: :master)
						slot = slot_for(key)
						client = client_for(slot, role)
						
						return client.call("GET", key)
					end
					
					# Get the bit value at offset in the string value stored at key.
					# @parameter key [String] The key to get bit from.
					# @parameter offset [Integer] The bit offset.
					# @parameter role [Symbol] The role of node to use (`:master` or `:slave`).
					# @returns [Integer] The bit value (0 or 1).
					def getbit(key, offset, role: :master)
						slot = slot_for(key)
						client = client_for(slot, role)
						
						return client.call("GETBIT", key, offset)
					end
					
					# Get a substring of the string stored at a key.
					# @parameter key [String] The key to get range from.
					# @parameter start_index [Integer] The start position.
					# @parameter end_index [Integer] The end position.
					# @parameter role [Symbol] The role of node to use (`:master` or `:slave`).
					# @returns [String] The substring.
					def getrange(key, start_index, end_index, role: :master)
						slot = slot_for(key)
						client = client_for(slot, role)
						
						return client.call("GETRANGE", key, start_index, end_index)
					end
					
					# Set the string value of a key and return its old value.
					# @parameter key [String] The key to set.
					# @parameter value [String] The new value.
					# @parameter role [Symbol] The role of node to use (`:master` or `:slave`).
					# @returns [String | nil] The old value, or `nil` if key didn't exist.
					def getset(key, value, role: :master)
						slot = slot_for(key)
						client = client_for(slot, role)
						
						return client.call("GETSET", key, value)
					end
					
					# Increment the integer value of a key by one.
					# @parameter key [String] The key to increment.
					# @parameter role [Symbol] The role of node to use (`:master` or `:slave`).
					# @returns [Integer] The value after incrementing.
					def incr(key, role: :master)
						slot = slot_for(key)
						client = client_for(slot, role)
						
						return client.call("INCR", key)
					end
					
					# Increment the integer value of a key by the given amount.
					# @parameter key [String] The key to increment.
					# @parameter increment [Integer] The amount to increment by.
					# @parameter role [Symbol] The role of node to use (`:master` or `:slave`).
					# @returns [Integer] The value after incrementing.
					def incrby(key, increment, role: :master)
						slot = slot_for(key)
						client = client_for(slot, role)
						
						return client.call("INCRBY", key, increment)
					end
					
					# Increment the float value of a key by the given amount.
					# @parameter key [String] The key to increment.
					# @parameter increment [Float] The amount to increment by.
					# @parameter role [Symbol] The role of node to use (`:master` or `:slave`).
					# @returns [String] The value after incrementing (as string).
					def incrbyfloat(key, increment, role: :master)
						slot = slot_for(key)
						client = client_for(slot, role)
						
						return client.call("INCRBYFLOAT", key, increment)
					end
					
					# Get the values of all the given keys.
					# Uses the cluster-aware multi-key handling from generic methods.
					# @parameter keys [Array(String)] The keys to get.
					# @parameter role [Symbol] The role of node to use (`:master` or `:slave`).
					# @returns [Array] The values for the given keys, in order.
					def mget(*keys, role: :master)
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
					
					# Set multiple keys to multiple values.
					# Redis will return a CROSSSLOT error if keys span multiple slots.
					# @parameter pairs [Hash] The key-value pairs to set.
					# @parameter role [Symbol] The role of node to use (`:master` or `:slave`).
					# @returns [String] Status reply.
					def mset(pairs, role: :master)
						return if pairs.empty?
						
						if pairs.is_a?(Hash)
							pairs = pairs.to_a.flatten
						end
						
						slot = slot_for(pairs.first)
						client = client_for(slot, role)
						
						return client.call("MSET", *pairs)
					end
					
					# Set multiple keys to multiple values, only if none exist.
					# Redis will return a CROSSSLOT error if keys span multiple slots.
					# @parameter pairs [Hash] The key-value pairs to set.
					# @parameter role [Symbol] The role of node to use (`:master` or `:slave`).
					# @returns [Integer] 1 if all keys were set, 0 otherwise.
					def msetnx(pairs, role: :master)
						keys = pairs.keys
						return 0 if keys.empty?
						
						flattened_pairs = pairs.keys.zip(pairs.values).flatten
						slot = slot_for(keys.first)
						client = client_for(slot, role)
						
						return client.call("MSETNX", *flattened_pairs)
					end
					
					# Set the value and expiration in milliseconds of a key.
					# @parameter key [String] The key to set.
					# @parameter milliseconds [Integer] The expiration time in milliseconds.
					# @parameter value [String] The value to set.
					# @parameter role [Symbol] The role of node to use (`:master` or `:slave`).
					# @returns [String] Status reply.
					def psetex(key, milliseconds, value, role: :master)
						slot = slot_for(key)
						client = client_for(slot, role)
						
						return client.call("PSETEX", key, milliseconds, value)
					end
					
					# Set the string value of a key.
					# @parameter key [String] The key to set.
					# @parameter value [String] The value to set.
					# @parameter update [Boolean | nil] If `true`, only update existing keys. If `false`, only set new keys.
					# @parameter seconds [Integer | nil] Expiration time in seconds.
					# @parameter milliseconds [Integer | nil] Expiration time in milliseconds.
					# @parameter role [Symbol] The role of node to use (`:master` or `:slave`).
					# @returns [String] Status reply.
					def set(key, value, update: nil, seconds: nil, milliseconds: nil, role: :master)
						arguments = []
						
						if seconds
							arguments << "EX" << seconds
						end
						
						if milliseconds
							arguments << "PX" << milliseconds
						end
						
						if update == true
							arguments << "XX"
						elsif update == false
							arguments << "NX"
						end
						
						slot = slot_for(key)
						client = client_for(slot, role)
						
						return client.call("SET", key, value, *arguments)
					end
					
					# Set or clear the bit at offset in the string value stored at key.
					# @parameter key [String] The key to modify.
					# @parameter offset [Integer] The bit offset.
					# @parameter value [Integer] The bit value (0 or 1).
					# @parameter role [Symbol] The role of node to use (`:master` or `:slave`).
					# @returns [Integer] The original bit value.
					def setbit(key, offset, value, role: :master)
						slot = slot_for(key)
						client = client_for(slot, role)
						
						return client.call("SETBIT", key, offset, value)
					end
					
					# Set the value and expiration of a key.
					# @parameter key [String] The key to set.
					# @parameter seconds [Integer] The expiration time in seconds.
					# @parameter value [String] The value to set.
					# @parameter role [Symbol] The role of node to use (`:master` or `:slave`).
					# @returns [String] Status reply.
					def setex(key, seconds, value, role: :master)
						slot = slot_for(key)
						client = client_for(slot, role)
						
						return client.call("SETEX", key, seconds, value)
					end
					
					# Set the value of a key, only if the key does not exist.
					# @parameter key [String] The key to set.
					# @parameter value [String] The value to set.
					# @parameter role [Symbol] The role of node to use (`:master` or `:slave`).
					# @returns [Boolean] `true` if the key was set, `false` otherwise.
					def setnx(key, value, role: :master)
						slot = slot_for(key)
						client = client_for(slot, role)
						
						return client.call("SETNX", key, value) == 1
					end
					
					# Overwrite part of a string at key starting at the specified offset.
					# @parameter key [String] The key to modify.
					# @parameter offset [Integer] The offset to start overwriting at.
					# @parameter value [String] The value to write.
					# @parameter role [Symbol] The role of node to use (`:master` or `:slave`).
					# @returns [Integer] The length of the string after modification.
					def setrange(key, offset, value, role: :master)
						slot = slot_for(key)
						client = client_for(slot, role)
						
						return client.call("SETRANGE", key, offset, value)
					end
					
					# Get the length of the value stored in a key.
					# @parameter key [String] The key to get length of.
					# @parameter role [Symbol] The role of node to use (`:master` or `:slave`).
					# @returns [Integer] The length of the string value, or 0 if key doesn't exist.
					def strlen(key, role: :master)
						slot = slot_for(key)
						client = client_for(slot, role)
						
						return client.call("STRLEN", key)
					end
				end
			end
		end
	end
end
