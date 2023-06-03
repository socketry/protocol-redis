# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2019-2023, by Samuel Williams.

module Protocol
	module Redis
		module Methods
			module Counting
				# Adds the specified elements to the specified HyperLogLog. O(1) to add every element.
				# @see https://redis.io/commands/pfadd
				# @param key [Key]
				# @param element [String]
				def pfadd(key, element, *elements)
					call("PFADD", key, element, *elements)
				end
				
				# Return the approximated cardinality of the set(s) observed by the HyperLogLog at key(s). O(1) with a very small average constant time when called with a single key. O(N) with N being the number of keys, and much bigger constant times, when called with multiple keys.
				# @see https://redis.io/commands/pfcount
				# @param key [Key]
				def pfcount(key, *keys)
					call("PFCOUNT", key, *keys)
				end
				
				# Merge N different HyperLogLogs into a single one. O(N) to merge N HyperLogLogs, but with high constant times.
				# @see https://redis.io/commands/pfmerge
				# @param destkey [Key]
				# @param sourcekey [Key]
				def pfmerge(destkey, sourcekey, *sourcekeys)
					call("PFMERGE", destkey, sourcekey, *sourcekeys)
				end
			end
		end
	end
end
