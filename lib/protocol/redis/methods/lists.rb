# frozen_string_literal: true

# Copyright, 2018, by Samuel G. D. Williams. <http://www.codeotaku.com>
# Copyright, 2018, by Huba Nagy.
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
			module Lists
				# Remove and get the first element in a list, or block until one is available. O(1).
				# @see https://redis.io/commands/blpop
				# @param key [Key]
				# @param timeout [Integer]
				def blpop(*keys, timeout: 0)
					return call('BLPOP', *keys, timeout)
				end
				
				# Remove and get the last element in a list, or block until one is available. O(1).
				# @see https://redis.io/commands/brpop
				# @param key [Key]
				# @param timeout [Integer]
				def brpop(*keys, timeout: 0)
					return call('BRPOP', *keys, timeout)
				end
				
				# Pop an element from a list, push it to another list and return it; or block until one is available. O(1).
				# @see https://redis.io/commands/brpoplpush
				# @param source [Key]
				# @param destination [Key]
				# @param timeout [Integer]
				def brpoplpush(source, destination, timeout)
					return call('BRPOPLPUSH', source, destination, timeout)
				end
				
				# Get an element from a list by its index. O(N) where N is the number of elements to traverse to get to the element at index. This makes asking for the first or the last element of the list O(1).
				# @see https://redis.io/commands/lindex
				# @param key [Key]
				# @param index [Integer]
				def lindex(key, index)
					return call('LINDEX', key, index)
				end
				
				# Insert an element before or after another element in a list. O(N) where N is the number of elements to traverse before seeing the value pivot. This means that inserting somewhere on the left end on the list (head) can be considered O(1) and inserting somewhere on the right end (tail) is O(N).
				# @see https://redis.io/commands/linsert
				# @param key [Key]
				# @param where [Enum]
				# @param pivot [String]
				# @param element [String]
				def linsert(key, position=:before, index, value)
					if position == :before
						offset = 'BEFORE'
					else
						offset = 'AFTER'
					end
					
					return call('LINSERT', key, offset, index, value)
				end
				
				# Get the length of a list. O(1).
				# @see https://redis.io/commands/llen
				# @param key [Key]
				def llen(key)
					return call('LLEN', key)
				end
				
				# Remove and get the first element in a list. O(1).
				# @see https://redis.io/commands/lpop
				# @param key [Key]
				def lpop(key)
					return call('LPOP', key)
				end
				
				# Prepend one or multiple elements to a list. O(1) for each element added, so O(N) to add N elements when the command is called with multiple arguments.
				# @see https://redis.io/commands/lpush
				# @param key [Key]
				# @param element [String]
				def lpush(key, value, *values)
					case value
					when Array
						values = value
					else
						values = [value] + values
					end
					
					return call('LPUSH', key, *values)
				end
				
				# Prepend an element to a list, only if the list exists. O(1) for each element added, so O(N) to add N elements when the command is called with multiple arguments.
				# @see https://redis.io/commands/lpushx
				# @param key [Key]
				# @param element [String]
				def lpushx(key, value)
					return call('LPUSHX', key, value)
				end
				
				# Get a range of elements from a list. O(S+N) where S is the distance of start offset from HEAD for small lists, from nearest end (HEAD or TAIL) for large lists; and N is the number of elements in the specified range.
				# @see https://redis.io/commands/lrange
				# @param key [Key]
				# @param start [Integer]
				# @param stop [Integer]
				def lrange(key, start, stop)
					return call('LRANGE', key, start, stop)
				end
				
				# Remove elements from a list. O(N+M) where N is the length of the list and M is the number of elements removed.
				# @see https://redis.io/commands/lrem
				# @param key [Key]
				# @param count [Integer]
				# @param element [String]
				def lrem(key, count, value)
					return call('LREM', key, count, value)
				end
				
				# Set the value of an element in a list by its index. O(N) where N is the length of the list. Setting either the first or the last element of the list is O(1).
				# @see https://redis.io/commands/lset
				# @param key [Key]
				# @param index [Integer]
				# @param element [String]
				def lset(key, index, values)
					return call('LSET', key, index, values)
				end
				
				# Trim a list to the specified range. O(N) where N is the number of elements to be removed by the operation.
				# @see https://redis.io/commands/ltrim
				# @param key [Key]
				# @param start [Integer]
				# @param stop [Integer]
				def ltrim(key, start, stop)
					return call('LTRIM', key, start, stop)
				end
				
				# Remove and get the last element in a list. O(1).
				# @see https://redis.io/commands/rpop
				# @param key [Key]
				def rpop(key)
					return call('RPOP', key)
				end
				
				# Remove the last element in a list, prepend it to another list and return it. O(1).
				# @see https://redis.io/commands/rpoplpush
				# @param source [Key]
				# @param destination [Key]
				def rpoplpush(source, destination=nil)
					destination = source if destination.nil?
					
					return call('RPOPLPUSH', source, destination)
				end
				
				# Append one or multiple elements to a list. O(1) for each element added, so O(N) to add N elements when the command is called with multiple arguments.
				# @see https://redis.io/commands/rpush
				# @param key [Key]
				# @param element [String]
				def rpush(key, value, *values)
					case value
					when Array
						values = value
					else
						values = [value] + values
					end
					
					return call('RPUSH', key, *values)
				end
				
				# Append an element to a list, only if the list exists. O(1) for each element added, so O(N) to add N elements when the command is called with multiple arguments.
				# @see https://redis.io/commands/rpushx
				# @param key [Key]
				# @param element [String]
				def rpushx(key, value)
					return call('RPUSHX', key, value)
				end
			end
		end
	end
end
