# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2019-2023, by Samuel Williams.
# Copyright, 2020, by Salim Semaoune.

module Protocol
	module Redis
		module Methods
			# Methods for managing Redis lists.
			module Lists
				# Remove and get the first element in a list, or block until one is available. O(1).
				# See <https://redis.io/commands/blpop> for more details.
				# @parameter key [Key]
				# @parameter timeout [Integer]
				def blpop(*keys, timeout: 0)
					call("BLPOP", *keys, timeout)
				end
				
				# Remove and get the last element in a list, or block until one is available. O(1).
				# See <https://redis.io/commands/brpop> for more details.
				# @parameter key [Key]
				# @parameter timeout [Integer]
				def brpop(*keys, timeout: 0)
					call("BRPOP", *keys, timeout)
				end
				
				# Pop an element from a list, push it to another list and return it; or block until one is available. O(1).
				# See <https://redis.io/commands/brpoplpush> for more details.
				# @parameter source [Key]
				# @parameter destination [Key]
				# @parameter timeout [Integer]
				def brpoplpush(source, destination, timeout)
					call("BRPOPLPUSH", source, destination, timeout)
				end
				
				# Get an element from a list by its index. O(N) where N is the number of elements to traverse to get to the element at index. This makes asking for the first or the last element of the list O(1).
				# See <https://redis.io/commands/lindex> for more details.
				# @parameter key [Key]
				# @parameter index [Integer]
				def lindex(key, index)
					call("LINDEX", key, index)
				end
				
				# Insert an element before or after another element in a list. O(N) where N is the number of elements to traverse before seeing the value pivot. This means that inserting somewhere on the left end on the list (head) can be considered O(1) and inserting somewhere on the right end (tail) is O(N).
				# See <https://redis.io/commands/linsert> for more details.
				# @parameter key [Key]
				# @parameter where [Enum]
				# @parameter pivot [String]
				# @parameter element [String]
				def linsert(key, position=:before, index, value)
					if position == :before
						offset = "BEFORE"
					else
						offset = "AFTER"
					end
					
					call("LINSERT", key, offset, index, value)
				end
				
				# Get the length of a list. O(1).
				# See <https://redis.io/commands/llen> for more details.
				# @parameter key [Key]
				def llen(key)
					call("LLEN", key)
				end
				
				# Remove and get the first element in a list. O(1).
				# See <https://redis.io/commands/lpop> for more details.
				# @parameter key [Key]
				def lpop(key)
					call("LPOP", key)
				end
				
				# Prepend one or multiple elements to a list. O(1) for each element added, so O(N) to add N elements when the command is called with multiple arguments.
				# See <https://redis.io/commands/lpush> for more details.
				# @parameter key [Key]
				# @parameter element [String]
				def lpush(key, value, *values)
					case value
					when Array
						values = value
					else
						values = [value] + values
					end
					
					call("LPUSH", key, *values)
				end
				
				# Prepend an element to a list, only if the list exists. O(1) for each element added, so O(N) to add N elements when the command is called with multiple arguments.
				# See <https://redis.io/commands/lpushx> for more details.
				# @parameter key [Key]
				# @parameter element [String]
				def lpushx(key, value)
					call("LPUSHX", key, value)
				end
				
				# Get a range of elements from a list. O(S+N) where S is the distance of start offset from HEAD for small lists, from nearest end (HEAD or TAIL) for large lists; and N is the number of elements in the specified range.
				# See <https://redis.io/commands/lrange> for more details.
				# @parameter key [Key]
				# @parameter start [Integer]
				# @parameter stop [Integer]
				def lrange(key, start, stop)
					call("LRANGE", key, start, stop)
				end
				
				# Remove elements from a list. O(N+M) where N is the length of the list and M is the number of elements removed.
				# See <https://redis.io/commands/lrem> for more details.
				# @parameter key [Key]
				# @parameter count [Integer]
				# @parameter element [String]
				def lrem(key, count, value)
					call("LREM", key, count, value)
				end
				
				# Set the value of an element in a list by its index. O(N) where N is the length of the list. Setting either the first or the last element of the list is O(1).
				# See <https://redis.io/commands/lset> for more details.
				# @parameter key [Key]
				# @parameter index [Integer]
				# @parameter element [String]
				def lset(key, index, values)
					call("LSET", key, index, values)
				end
				
				# Trim a list to the specified range. O(N) where N is the number of elements to be removed by the operation.
				# See <https://redis.io/commands/ltrim> for more details.
				# @parameter key [Key]
				# @parameter start [Integer]
				# @parameter stop [Integer]
				def ltrim(key, start, stop)
					call("LTRIM", key, start, stop)
				end
				
				# Remove and get the last element in a list. O(1).
				# See <https://redis.io/commands/rpop> for more details.
				# @parameter key [Key]
				def rpop(key)
					call("RPOP", key)
				end
				
				# Remove the last element in a list, prepend it to another list and return it. O(1).
				# See <https://redis.io/commands/rpoplpush> for more details.
				# @parameter source [Key]
				# @parameter destination [Key]
				def rpoplpush(source, destination=nil)
					destination = source if destination.nil?
					
					call("RPOPLPUSH", source, destination)
				end
				
				# Append one or multiple elements to a list. O(1) for each element added, so O(N) to add N elements when the command is called with multiple arguments.
				# See <https://redis.io/commands/rpush> for more details.
				# @parameter key [Key]
				# @parameter element [String]
				def rpush(key, value, *values)
					case value
					when Array
						values = value
					else
						values = [value] + values
					end
					
					call("RPUSH", key, *values)
				end
				
				# Append an element to a list, only if the list exists. O(1) for each element added, so O(N) to add N elements when the command is called with multiple arguments.
				# See <https://redis.io/commands/rpushx> for more details.
				# @parameter key [Key]
				# @parameter element [String]
				def rpushx(key, value)
					call("RPUSHX", key, value)
				end
			end
		end
	end
end
