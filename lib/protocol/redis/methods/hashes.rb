# frozen_string_literal: true

# Copyright, 2019, by Mikael Henriksson. <http://www.mhenrixon.com>
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

module Protocol
	module Redis
		module Methods
			module Hashes
				# Get the number of fields in a hash. O(1).
				# @see https://redis.io/commands/hlen
				# @param key [Key]
				# @return [Integer]
				def hlen(key)
					call('HLEN', key)
				end
				
				# Set the string value of a hash field. O(1) for each field/value pair added, so O(N) to add N field/value pairs when the command is called with multiple field/value pairs.
				# @see https://redis.io/commands/hset
				# @param key [Key]
				# @return [Integer]
				def hset(key, field, value)
					call('HSET', key, field, value)
				end
				
				# Set the value of a hash field, only if the field does not exist. O(1).
				# @see https://redis.io/commands/hsetnx
				# @param key [Key]
				# @param field [String]
				# @param value [String]
				# @return [Boolean]
				def hsetnx(key, field, value)
					call('HSETNX', key, field, value) > 0
				end
				
				# Set multiple hash fields to multiple values. O(N) where N is the number of fields being set.
				# @see https://redis.io/commands/hmset
				# @param key [Key]
				# @return [String] default: "OK"
				def hmset(key, *attrs)
					call('HMSET', key, *attrs)
				end
				
				# Get the value of a hash field. O(1).
				# @see https://redis.io/commands/hget
				# @param key [Key]
				# @param field [String]
				# @return [String, Null]
				def hget(key, field)
					call('HGET', key, field)
				end
				
				# Get the values of all the given hash fields. O(N) where N is the number of fields being requested.
				# @see https://redis.io/commands/hmget
				# @param key [Key]
				# @param field [String]
				# @return [Array]
				def hmget(key, *fields)
					call('HMGET', key, *fields)
				end
				
				# Delete one or more hash fields. O(N) where N is the number of fields to be removed.
				# @see https://redis.io/commands/hdel
				# @param key [Key]
				# @param field [String]
				# @return [Integer]
				def hdel(key, *fields)
					call('HDEL', key, *fields)
				end
				
				# Determine if a hash field exists. O(1).
				# @see https://redis.io/commands/hexists
				# @param key [Key]
				# @param field [String]
				# @return [Boolean]
				def hexists(key, field)
					call('HEXISTS', key, field) > 0
				end
				
				# Increment the integer value of a hash field by the given number. O(1).
				# @see https://redis.io/commands/hincrby
				# @param key [Key]
				# @param field [String]
				# @param increment [Integer]
				# @return [Integer]
				def hincrby(key, field, increment)
					call('HINCRBY', key, field, increment)
				end
				
				# Increment the float value of a hash field by the given amount. O(1).
				# @see https://redis.io/commands/hincrbyfloat
				# @param key [Key]
				# @param field [String]
				# @param increment [Double]
				# @return [Float]
				def hincrbyfloat(key, field, increment)
					Float(call('HINCRBYFLOAT', key, field, increment))
				end
				
				# Get all the fields in a hash. O(N) where N is the size of the hash.
				# @see https://redis.io/commands/hkeys
				# @param key [Key]
				# @return [Array]
				def hkeys(key)
					call('HKEYS', key)
				end
				
				# Get all the values in a hash. O(N) where N is the size of the hash.
				# @see https://redis.io/commands/hvals
				# @param key [Key]
				# @return [Array]
				def hvals(key)
					call('HVALS', key)
				end
				
				# Get all the fields and values in a hash. O(N) where N is the size of the hash.
				# @see https://redis.io/commands/hgetall
				# @param key [Key]
				# @return [Hash]
				def hgetall(key)
					call('HGETALL', key).each_slice(2).to_h
				end
			end
		end
	end
end
