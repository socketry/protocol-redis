# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2019-2025, by Samuel Williams.
# Copyright, 2023, by Troex Nevelin.
# Copyright, 2023, by Nick Burwell.

module Protocol
	module Redis
		module Methods
			# Methods for managing Redis hashes.
			module Hashes
				# Get the number of fields in a hash. O(1).
				# See <https://redis.io/commands/hlen> for more details.
				# @parameter key [Key]
				# @returns [Integer]
				def hlen(key)
					call("HLEN", key)
				end
				
				# Set the string value of a hash field. O(1) for each field/value pair added, so O(N) to add N field/value pairs when the command is called with multiple field/value pairs.
				# See <https://redis.io/commands/hset> for more details.
				# @parameter key [Key]
				# @returns [Integer] if new field added returns "1" otherwise "0"
				def hset(key, field, value)
					call("HSET", key, field, value)
				end
				
				# Set the value of a hash field, only if the field does not exist. O(1).
				# See <https://redis.io/commands/hsetnx> for more details.
				# @parameter key [Key]
				# @parameter field [String]
				# @parameter value [String]
				# @returns [Boolean] "true" if new field added, "false" otherwise
				def hsetnx(key, field, value)
					call("HSETNX", key, field, value) > 0
				end
				
				# Set multiple hash fields to multiple values. O(N) where N is the number of fields being set.
				# See <https://redis.io/commands/hmset> for more details.
				# @parameter key [Key]
				# @returns [String] default: "OK"
				def hmset(key, *attrs)
					call("HMSET", key, *attrs)
				end
				
				# Set multiple hash fields to multiple values, by providing a hash
				#
				# @example
				#   redis.mapped_hmset("hash", { "f1" => "v1", "f2" => "v2" })
				#     # => "OK"
				#
				# @parameter key [Key]
				# @parameter hash [Hash] a non-empty hash with fields mapping to values
				# @returns [String] default: "OK"
				#
				# See <#hmset> for more details.
				def mapped_hmset(key, hash)
					hmset(key, *hash.flatten)
				end
				
				# Get the value of a hash field. O(1).
				# See <https://redis.io/commands/hget> for more details.
				# @parameter key [Key]
				# @parameter field [String]
				# @returns [String, Null]
				def hget(key, field)
					call("HGET", key, field)
				end
				
				# Get the values of all the given hash fields. O(N) where N is the number of fields being requested.
				# See <https://redis.io/commands/hmget> for more details.
				# @parameter key [Key]
				# @parameter fields [Array(String)] array of fields
				# @returns [Array]
				def hmget(key, *fields)
					call("HMGET", key, *fields)
				end
				
				# Get the values of all the given hash fields and return as array
				#
				# @example
				#   redis.mapped_hmget("hash", "f1", "f2")
				#     # => { "f1" => "v1", "f2" => "v2" }
				#
				# @parameter key [Key]
				# @parameter fields [Array(String)] array of fields
				# @returns [Hash] a hash mapping the specified fields to their values
				#
				# See <#hmget> for more details.
				def mapped_hmget(key, *fields)
					reply = hmget(key, *fields)
					Hash[fields.zip(reply)]
				end
				
				# Delete one or more hash fields. O(N) where N is the number of fields to be removed.
				# See <https://redis.io/commands/hdel> for more details.
				# @parameter key [Key]
				# @parameter field [String]
				# @returns [Integer] number of deleted fields
				def hdel(key, *fields)
					call("HDEL", key, *fields)
				end
				
				# Determine if a hash field exists. O(1).
				# See <https://redis.io/commands/hexists> for more details.
				# @parameter key [Key]
				# @parameter field [String]
				# @returns [Boolean]
				def hexists(key, field)
					call("HEXISTS", key, field) > 0
				end
				
				# Increment the integer value of a hash field by the given number. O(1).
				# See <https://redis.io/commands/hincrby> for more details.
				# @parameter key [Key]
				# @parameter field [String]
				# @parameter increment [Integer]
				# @returns [Integer] field value after increment
				def hincrby(key, field, increment)
					call("HINCRBY", key, field, increment)
				end
				
				# Increment the float value of a hash field by the given amount. O(1).
				# See <https://redis.io/commands/hincrbyfloat> for more details.
				# @parameter key [Key]
				# @parameter field [String]
				# @parameter increment [Double]
				# @returns [Float] field value after increment
				def hincrbyfloat(key, field, increment)
					Float(call("HINCRBYFLOAT", key, field, increment))
				end
				
				# Get all the fields in a hash. O(N) where N is the size of the hash.
				# See <https://redis.io/commands/hkeys> for more details.
				# @parameter key [Key]
				# @returns [Array]
				def hkeys(key)
					call("HKEYS", key)
				end
				
				# Get all the values in a hash. O(N) where N is the size of the hash.
				# See <https://redis.io/commands/hvals> for more details.
				# @parameter key [Key]
				# @returns [Array]
				def hvals(key)
					call("HVALS", key)
				end
				
				# Get all the fields and values in a hash. O(N) where N is the size of the hash.
				# See <https://redis.io/commands/hgetall> for more details.
				# @parameter key [Key]
				# @returns [Hash | Nil]
				def hgetall(key)
					if pairs = call("HGETALL", key)
						pairs.each_slice(2).to_h
					end
				end
				
				# Iterates fields of Hash types and their associated values. O(1) for every call. O(N) for a complete iteration, including enough command calls for the cursor to return back to 0. N is the number of elements inside the collection.
				# See <https://redis.io/commands/hscan/> for more details.
				# @parameter cursor [Cursor]
				# @returns [Hash]
				def hscan(key, cursor = "0", match: nil, count: nil)
					arguments = [key, cursor]
					
					if match
						arguments.append("MATCH", match)
					end
					
					if count
						arguments.append("COUNT", count)
					end
					
					call("HSCAN", *arguments)
				end
				
				# Iterate over each field and the value of the hash, using HSCAN.
				def hscan_each(key, cursor = "0", match: nil, count: nil, &block)
					return enum_for(:hscan_each, key, cursor, match: match, count: count) unless block_given?
					
					while true
						cursor, data = hscan(key, cursor, match: match, count: count)
						
						data.each_slice(2, &block)
						
						break if cursor == "0"
					end
				end
			end
		end
	end
end
