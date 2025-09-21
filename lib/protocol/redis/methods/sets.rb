# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2020-2025, by Samuel Williams.

module Protocol
	module Redis
		module Methods
			# Methods for managing Redis sets.
			module Sets
				# Add one or more members to a set. O(1) for each element added, so O(N) to add N elements when the command is called with multiple arguments.
				# See <https://redis.io/commands/sadd> for more details.
				# @parameter key [Key]
				# @parameter member [String]
				def sadd(*arguments)
					call("SADD", *arguments)
				end
				
				# Get the number of members in a set. O(1).
				# See <https://redis.io/commands/scard> for more details.
				# @parameter key [Key]
				def scard(*arguments)
					call("SCARD", *arguments)
				end
				
				# Subtract multiple sets. O(N) where N is the total number of elements in all given sets.
				# See <https://redis.io/commands/sdiff> for more details.
				# @parameter key [Key]
				def sdiff(*arguments)
					call("SDIFF", *arguments)
				end
				
				# Subtract multiple sets and store the resulting set in a key. O(N) where N is the total number of elements in all given sets.
				# See <https://redis.io/commands/sdiffstore> for more details.
				# @parameter destination [Key]
				# @parameter key [Key]
				def sdiffstore(*arguments)
					call("SDIFFSTORE", *arguments)
				end
				
				# Intersect multiple sets. O(N*M) worst case where N is the cardinality of the smallest set and M is the number of sets.
				# See <https://redis.io/commands/sinter> for more details.
				# @parameter key [Key]
				def sinter(*arguments)
					call("SINTER", *arguments)
				end
				
				# Intersect multiple sets and store the resulting set in a key. O(N*M) worst case where N is the cardinality of the smallest set and M is the number of sets.
				# See <https://redis.io/commands/sinterstore> for more details.
				# @parameter destination [Key]
				# @parameter key [Key]
				def sinterstore(*arguments)
					call("SINTERSTORE", *arguments)
				end
				
				# Determine if a given value is a member of a set. O(1).
				# See <https://redis.io/commands/sismember> for more details.
				# @parameter key [Key]
				# @parameter member [String]
				def sismember(*arguments)
					call("SISMEMBER", *arguments)
				end
				
				# Get all the members in a set. O(N) where N is the set cardinality.
				# See <https://redis.io/commands/smembers> for more details.
				# @parameter key [Key]
				def smembers(*arguments)
					call("SMEMBERS", *arguments)
				end
				
				# Move a member from one set to another. O(1).
				# See <https://redis.io/commands/smove> for more details.
				# @parameter source [Key]
				# @parameter destination [Key]
				# @parameter member [String]
				def smove(*arguments)
					call("SMOVE", *arguments)
				end
				
				# Remove and return one or multiple random members from a set. O(1).
				# See <https://redis.io/commands/spop> for more details.
				# @parameter key [Key]
				# @parameter count [Integer]
				def spop(*arguments)
					call("SPOP", *arguments)
				end
				
				# Get one or multiple random members from a set. Without the count argument O(1), otherwise O(N) where N is the absolute value of the passed count.
				# See <https://redis.io/commands/srandmember> for more details.
				# @parameter key [Key]
				# @parameter count [Integer]
				def srandmember(*arguments)
					call("SRANDMEMBER", *arguments)
				end
				
				# Remove one or more members from a set. O(N) where N is the number of members to be removed.
				# See <https://redis.io/commands/srem> for more details.
				# @parameter key [Key]
				# @parameter member [String]
				def srem(*arguments)
					call("SREM", *arguments)
				end
				
				# Add multiple sets. O(N) where N is the total number of elements in all given sets.
				# See <https://redis.io/commands/sunion> for more details.
				# @parameter key [Key]
				def sunion(*arguments)
					call("SUNION", *arguments)
				end
				
				# Add multiple sets and store the resulting set in a key. O(N) where N is the total number of elements in all given sets.
				# See <https://redis.io/commands/sunionstore> for more details.
				# @parameter destination [Key]
				# @parameter key [Key]
				def sunionstore(*arguments)
					call("SUNIONSTORE", *arguments)
				end
				
				# Incrementally iterate Set elements. O(1) for every call. O(N) for a complete iteration, including enough command calls for the cursor to return back to 0. N is the number of elements inside the collection..
				# See <https://redis.io/commands/sscan> for more details.
				# @parameter key [Key]
				# @parameter cursor [Integer]
				def sscan(*arguments)
					call("SSCAN", *arguments)
				end
			end
		end
	end
end
