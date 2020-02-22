# frozen_string_literal: true

# Copyright, 2018, by Samuel G. D. Williams. <http://www.codeotaku.com>
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
			module Sets
				# Add one or more members to a set. O(1) for each element added, so O(N) to add N elements when the command is called with multiple arguments.
				# @see https://redis.io/commands/sadd
				# @param key [Key]
				# @param member [String]
				def sadd(*arguments)
					call("SADD", *arguments)
				end
				
				# Get the number of members in a set. O(1).
				# @see https://redis.io/commands/scard
				# @param key [Key]
				def scard(*arguments)
					call("SCARD", *arguments)
				end
				
				# Subtract multiple sets. O(N) where N is the total number of elements in all given sets.
				# @see https://redis.io/commands/sdiff
				# @param key [Key]
				def sdiff(*arguments)
					call("SDIFF", *arguments)
				end
				
				# Subtract multiple sets and store the resulting set in a key. O(N) where N is the total number of elements in all given sets.
				# @see https://redis.io/commands/sdiffstore
				# @param destination [Key]
				# @param key [Key]
				def sdiffstore(*arguments)
					call("SDIFFSTORE", *arguments)
				end
				
				# Intersect multiple sets. O(N*M) worst case where N is the cardinality of the smallest set and M is the number of sets.
				# @see https://redis.io/commands/sinter
				# @param key [Key]
				def sinter(*arguments)
					call("SINTER", *arguments)
				end
				
				# Intersect multiple sets and store the resulting set in a key. O(N*M) worst case where N is the cardinality of the smallest set and M is the number of sets.
				# @see https://redis.io/commands/sinterstore
				# @param destination [Key]
				# @param key [Key]
				def sinterstore(*arguments)
					call("SINTERSTORE", *arguments)
				end
				
				# Determine if a given value is a member of a set. O(1).
				# @see https://redis.io/commands/sismember
				# @param key [Key]
				# @param member [String]
				def sismember(*arguments)
					call("SISMEMBER", *arguments)
				end
				
				# Get all the members in a set. O(N) where N is the set cardinality.
				# @see https://redis.io/commands/smembers
				# @param key [Key]
				def smembers(*arguments)
					call("SMEMBERS", *arguments)
				end
				
				# Move a member from one set to another. O(1).
				# @see https://redis.io/commands/smove
				# @param source [Key]
				# @param destination [Key]
				# @param member [String]
				def smove(*arguments)
					call("SMOVE", *arguments)
				end
				
				# Remove and return one or multiple random members from a set. O(1).
				# @see https://redis.io/commands/spop
				# @param key [Key]
				# @param count [Integer]
				def spop(*arguments)
					call("SPOP", *arguments)
				end
				
				# Get one or multiple random members from a set. Without the count argument O(1), otherwise O(N) where N is the absolute value of the passed count.
				# @see https://redis.io/commands/srandmember
				# @param key [Key]
				# @param count [Integer]
				def srandmember(*arguments)
					call("SRANDMEMBER", *arguments)
				end
				
				# Remove one or more members from a set. O(N) where N is the number of members to be removed.
				# @see https://redis.io/commands/srem
				# @param key [Key]
				# @param member [String]
				def srem(*arguments)
					call("SREM", *arguments)
				end
				
				# Add multiple sets. O(N) where N is the total number of elements in all given sets.
				# @see https://redis.io/commands/sunion
				# @param key [Key]
				def sunion(*arguments)
					call("SUNION", *arguments)
				end
				
				# Add multiple sets and store the resulting set in a key. O(N) where N is the total number of elements in all given sets.
				# @see https://redis.io/commands/sunionstore
				# @param destination [Key]
				# @param key [Key]
				def sunionstore(*arguments)
					call("SUNIONSTORE", *arguments)
				end
				
				# Incrementally iterate Set elements. O(1) for every call. O(N) for a complete iteration, including enough command calls for the cursor to return back to 0. N is the number of elements inside the collection..
				# @see https://redis.io/commands/sscan
				# @param key [Key]
				# @param cursor [Integer]
				def sscan(*arguments)
					call("SSCAN", *arguments)
				end
			end
		end
	end
end
