# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2019-2023, by Samuel Williams.

module Protocol
	module Redis
		module Methods
			module Strings
				# Append a value to a key. O(1). The amortized time complexity is O(1) assuming the appended value is small and the already present value is of any size, since the dynamic string library used by Redis will double the free space available on every reallocation.
				# See <https://redis.io/commands/append> for more details.
				# @parameter key [Key]
				# @parameter value [String]
				def append(key, value)
					call("APPEND", key, value)
				end
				
				# Count set bits in a string. O(N).
				# See <https://redis.io/commands/bitcount> for more details.
				# @parameter key [Key]
				def bitcount(key, *range)
					call("BITCOUNT", key, *range)
				end
				
				# Decrement the integer value of a key by one. O(1).
				# See <https://redis.io/commands/decr> for more details.
				# @parameter key [Key]
				def decr(key)
					call("DECR", key)
				end
				
				# Decrement the integer value of a key by the given number. O(1).
				# See <https://redis.io/commands/decrby> for more details.
				# @parameter key [Key]
				# @parameter decrement [Integer]
				def decrby(key, decrement)
					call("DECRBY", key, decrement)
				end
				
				# Get the value of a key. O(1).
				# See <https://redis.io/commands/get> for more details.
				# @parameter key [Key]
				def get(key)
					call("GET", key)
				end
				
				# Returns the bit value at offset in the string value stored at key. O(1).
				# See <https://redis.io/commands/getbit> for more details.
				# @parameter key [Key]
				# @parameter offset [Integer]
				def getbit(key, offset)
					call("GETBIT", key, offset)
				end
				
				# Get a substring of the string stored at a key. O(N) where N is the length of the returned string. The complexity is ultimately determined by the returned length, but because creating a substring from an existing string is very cheap, it can be considered O(1) for small strings.
				# See <https://redis.io/commands/getrange> for more details.
				# @parameter key [Key]
				# @parameter start [Integer]
				# @parameter end [Integer]
				def getrange(key, start_index, end_index)
					call("GETRANGE", key, start_index, end_index)
				end
				
				# Set the string value of a key and return its old value. O(1).
				# See <https://redis.io/commands/getset> for more details.
				# @parameter key [Key]
				# @parameter value [String]
				def getset(key, value)
					call("GETSET", key, value)
				end
				
				# Increment the integer value of a key by one. O(1).
				# See <https://redis.io/commands/incr> for more details.
				# @parameter key [Key]
				def incr(key)
					call("INCR", key)
				end
				
				# Increment the integer value of a key by the given amount. O(1).
				# See <https://redis.io/commands/incrby> for more details.
				# @parameter key [Key]
				# @parameter increment [Integer]
				def incrby(key, increment)
					call("INCRBY", key, increment)
				end
				
				# Increment the float value of a key by the given amount. O(1).
				# See <https://redis.io/commands/incrbyfloat> for more details.
				# @parameter key [Key]
				# @parameter increment [Double]
				def incrbyfloat(key, increment)
					call("INCRBYFLOAT", key, increment)
				end
				
				# Get the values of all the given keys. O(N) where N is the number of keys to retrieve.
				# See <https://redis.io/commands/mget> for more details.
				# @parameter key [Key]
				def mget(key, *keys)
					call("MGET", key, *keys)
				end
				
				# Set multiple keys to multiple values. O(N) where N is the number of keys to set.
				# See <https://redis.io/commands/mset> for more details.
				def mset(pairs)
					flattened_pairs = pairs.keys.zip(pairs.values).flatten
					
					call("MSET", *flattened_pairs)
				end
				
				# Set multiple keys to multiple values, only if none of the keys exist. O(N) where N is the number of keys to set.
				# See <https://redis.io/commands/msetnx> for more details.
				def msetnx(pairs)
					flattened_pairs = pairs.keys.zip(pairs.values).flatten
					
					call("MSETNX", *flattened_pairs)
				end
				
				# Set the value and expiration in milliseconds of a key. O(1).
				# See <https://redis.io/commands/psetex> for more details.
				# @parameter key [Key]
				# @parameter milliseconds [Integer]
				# @parameter value [String]
				def psetex(key, milliseconds, value)
					call("PSETEX", key, milliseconds, value)
				end
				
				# Set the string value of a key. O(1).
				# See <https://redis.io/commands/set> for more details.
				# @parameter key [Key]
				# @parameter value [String]
				# @parameter expiration [Enum]
				# @parameter update [Boolean, nil] If true, only update elements that already exist (never add elements). If false, don't update existing elements (only add new elements).
				def set(key, value, update: nil, seconds: nil, milliseconds: nil)
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
					
					call("SET", key, value, *arguments)
				end
				
				# Sets or clears the bit at offset in the string value stored at key. O(1).
				# See <https://redis.io/commands/setbit> for more details.
				# @parameter key [Key]
				# @parameter offset [Integer]
				# @parameter value [Integer]
				def setbit(key, offset, value)
					call("SETBIT", key, offset, value)
				end
				
				# Set the value and expiration of a key. O(1).
				# See <https://redis.io/commands/setex> for more details.
				# @parameter key [Key]
				# @parameter seconds [Integer]
				# @parameter value [String]
				def setex(key, seconds, value)
					call("SETEX", key, seconds, value)
				end
				
				# Set the value of a key, only if the key does not exist. O(1).
				# @returns [Boolean] if the key was set.
				# See <https://redis.io/commands/setnx> for more details.
				# @parameter key [Key]
				# @parameter value [String]
				def setnx(key, value)
					call("SETNX", key, value) == 1
				end
				
				# Overwrite part of a string at key starting at the specified offset. O(1), not counting the time taken to copy the new string in place. Usually, this string is very small so the amortized complexity is O(1). Otherwise, complexity is O(M) with M being the length of the value argument.
				# See <https://redis.io/commands/setrange> for more details.
				# @parameter key [Key]
				# @parameter offset [Integer]
				# @parameter value [String]
				def setrange(key, offset, value)
					call("SETRANGE", key, offset, value)
				end
				
				# Get the length of the value stored in a key. O(1).
				# See <https://redis.io/commands/strlen> for more details.
				# @parameter key [Key]
				def strlen(key)
					call("STRLEN", key)
				end
			end
		end
	end
end
