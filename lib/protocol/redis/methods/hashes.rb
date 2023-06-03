# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2019-2023, by Samuel Williams.

module Protocol
	module Redis
		module Methods
			module Hashes
				# Get the number of fields in a hash. O(1).
				# @see https://redis.io/commands/hlen
				# @param key [Key]
				def hlen(key)
					call('HLEN', key)
				end
				
				# Set the string value of a hash field. O(1) for each field/value pair added, so O(N) to add N field/value pairs when the command is called with multiple field/value pairs.
				# @see https://redis.io/commands/hset
				# @param key [Key]
				def hset(key, field, value)
					call('HSET', key, field, value)
				end
				
				# Set the value of a hash field, only if the field does not exist. O(1).
				# @see https://redis.io/commands/hsetnx
				# @param key [Key]
				# @param field [String]
				# @param value [String]
				def hsetnx(key, field, value)
					call('HSETNX', key, field, value)
				end
				
				# Set multiple hash fields to multiple values. O(N) where N is the number of fields being set.
				# @see https://redis.io/commands/hmset
				# @param key [Key]
				def hmset(key, *attrs)
					call('HMSET', key, *attrs)
				end
				
				# Get the value of a hash field. O(1).
				# @see https://redis.io/commands/hget
				# @param key [Key]
				# @param field [String]
				def hget(key, field)
					call('HGET', key, field)
				end
				
				# Get the values of all the given hash fields. O(N) where N is the number of fields being requested.
				# @see https://redis.io/commands/hmget
				# @param key [Key]
				# @param field [String]
				def hmget(key, *fields, &blk)
					call('HMGET', key, *fields, &blk)
				end
				
				# Delete one or more hash fields. O(N) where N is the number of fields to be removed.
				# @see https://redis.io/commands/hdel
				# @param key [Key]
				# @param field [String]
				def hdel(key, *fields)
					call('HDEL', key, *fields)
				end
				
				# Determine if a hash field exists. O(1).
				# @see https://redis.io/commands/hexists
				# @param key [Key]
				# @param field [String]
				def hexists(key, field)
					call('HEXISTS', key, field)
				end
				
				# Increment the integer value of a hash field by the given number. O(1).
				# @see https://redis.io/commands/hincrby
				# @param key [Key]
				# @param field [String]
				# @param increment [Integer]
				def hincrby(key, field, increment)
					call('HINCRBY', key, field, increment)
				end
				
				# Increment the float value of a hash field by the given amount. O(1).
				# @see https://redis.io/commands/hincrbyfloat
				# @param key [Key]
				# @param field [String]
				# @param increment [Double]
				def hincrbyfloat(key, field, increment)
					call('HINCRBYFLOAT', key, field, increment)
				end
				
				# Get all the fields in a hash. O(N) where N is the size of the hash.
				# @see https://redis.io/commands/hkeys
				# @param key [Key]
				def hkeys(key)
					call('HKEYS', key)
				end
				
				# Get all the values in a hash. O(N) where N is the size of the hash.
				# @see https://redis.io/commands/hvals
				# @param key [Key]
				def hvals(key)
					call('HVALS', key)
				end
				
				# Get all the fields and values in a hash. O(N) where N is the size of the hash.
				# @see https://redis.io/commands/hgetall
				# @param key [Key]
				def hgetall(key)
					call('HGETALL', key)
				end
			end
		end
	end
end
