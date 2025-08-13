# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2020, by Dimitry Chopey.
# Copyright, 2020-2023, by Samuel Williams.

module Protocol
	module Redis
		module Methods
			# Methods for managing Redis sorted sets.
			module SortedSets
				# Remove and return the member with the lowest score from one or more sorted sets, or block until one is available. O(log(N)) with N being the number of elements in the sorted set.
				# See <https://redis.io/commands/bzpopmin> for more details.
				# @parameter key [Key]
				# @parameter timeout [Integer]
				def bzpopmin(*keys, timeout: 0)
					call("BZPOPMIN", *keys, timeout)
				end
				
				# Remove and return the member with the highest score from one or more sorted sets, or block until one is available. O(log(N)) with N being the number of elements in the sorted set.
				# See <https://redis.io/commands/bzpopmax> for more details.
				# @parameter key [Key]
				# @parameter timeout [Integer]
				def bzpopmax(*keys, timeout: 0)
					call("BZPOPMAX", *keys, timeout)
				end
				
				# Add one or more members to a sorted set, or update its score if it already exists. O(log(N)) for each item added, where N is the number of elements in the sorted set.
				# See <https://redis.io/commands/zadd> for more details.
				# @parameter key [Key]
				# @parameter score [Double]
				# @parameter member [String]
				# @parameter others [Array] an array of `score`, `member` elements.
				# @parameter update [Boolean, nil] If true, only update elements that already exist (never add elements). If false, don't update existing elements (only add new elements).
				# @parameter change [Boolean] Modify the return value from the number of new elements added,
				#   to the total number of elements changed; changed elements are new elements added
				#   and elements already existing for which the score was updated.
				# @parameter increment [Boolean] When this option is specified ZADD acts like ZINCRBY;
				#   only one score-element pair can be specified in this mode.
				def zadd(key, score, member, *others, update: nil, change: false, increment: false)
					arguments = ["ZADD", key]
					
					if update == true
						arguments.push("XX")
					elsif update == false
						arguments.push("NX")
					end
					
					arguments.push("CH") if change
					arguments.push("INCR") if increment
					
					arguments.push(score, member)
					arguments.push(*others)
					
					call(*arguments)
				end
				
				# Get the number of members in a sorted set. O(1).
				# See <https://redis.io/commands/zcard> for more details.
				# @parameter key [Key]
				def zcard(key)
					call("ZCARD", key)
				end
				
				# Count the members in a sorted set with scores within the given values. O(log(N)) with N being the number of elements in the sorted set.
				# See <https://redis.io/commands/zcount> for more details.
				# @parameter key [Key]
				# @parameter min [Double]
				# @parameter max [Double]
				def zcount(key, min, max)
					call("ZCOUNT", key, min, max)
				end
				
				# Increment the score of a member in a sorted set. O(log(N)) where N is the number of elements in the sorted set.
				# See <https://redis.io/commands/zincrby> for more details.
				# @parameter key [Key]
				# @parameter increment [Integer]
				# @parameter member [String]
				def zincrby(key, increment, member)
					call("ZINCRBY", key, increment, member)
				end
				
				# Intersect multiple sorted sets and store the resulting sorted set in a new key. O(N*K)+O(M*log(M)) worst case with N being the smallest input sorted set, K being the number of input sorted sets and M being the number of elements in the resulting sorted set.
				# See <https://redis.io/commands/zinterstore> for more details.
				# @parameter destination [Key]
				# @parameter keys [Array(Key)]
				# @parameter weights [Array(Integer)]
				# @parameter aggregate [Enum] one of sum, min, max.
				def zinterstore(destination, keys, weights = nil, aggregate: nil)
					arguments = []
					
					if weights
						if weights.size != keys.size
							raise ArgumentError, "#{weights.size} weights given for #{keys.size} keys!"
						end
						
						arguments.push("WEIGHTS")
						arguments.concat(weights)
					end
					
					if aggregate
						arguments.push("AGGREGATE", aggregate)
					end
					
					call("ZINTERSTORE", destination, keys.size, *keys, *arguments)
				end
				
				# Count the number of members in a sorted set between a given lexicographical range. O(log(N)) with N being the number of elements in the sorted set.
				# See <https://redis.io/commands/zlexcount> for more details.
				# @parameter key [Key]
				# @parameter min [String]
				# @parameter max [String]
				def zlexcount(key, min, max)
					call("ZLEXCOUNT", key, min, max)
				end
				
				# Remove and return members with the highest scores in a sorted set. O(log(N)*M) with N being the number of elements in the sorted set, and M being the number of elements popped.
				# See <https://redis.io/commands/zpopmax> for more details.
				# @parameter key [Key]
				# @parameter count [Integer]
				def zpopmax(key, count = 1)
					call("ZPOPMAX", key, count)
				end
				
				# Remove and return members with the lowest scores in a sorted set. O(log(N)*M) with N being the number of elements in the sorted set, and M being the number of elements popped.
				# See <https://redis.io/commands/zpopmin> for more details.
				# @parameter key [Key]
				# @parameter count [Integer]
				def zpopmin(key, count = 1)
					call("ZPOPMIN", key, count)
				end
				
				# Return a range of members in a sorted set, by index. O(log(N)+M) with N being the number of elements in the sorted set and M the number of elements returned.
				# See <https://redis.io/commands/zrange> for more details.
				# @parameter key [Key]
				# @parameter start [Integer]
				# @parameter stop [Integer]
				# @parameter with_scores [Boolean] Return the scores of the elements together with the elements.
				def zrange(key, start, stop, with_scores: false)
					arguments = [start, stop]
					
					arguments.push("WITHSCORES") if with_scores
					
					call("ZRANGE", key, *arguments)
				end
				
				# Return a range of members in a sorted set, by lexicographical range. O(log(N)+M) with N being the number of elements in the sorted set and M the number of elements being returned. If M is constant (e.g. always asking for the first 10 elements with LIMIT), you can consider it O(log(N)).
				# See <https://redis.io/commands/zrangebylex> for more details.
				# @parameter key [Key]
				# @parameter min [String]
				# @parameter max [String]
				# @parameter limit [Tuple(offset, count)] Limit the results to the specified `offset` and `count` items.
				def zrangebylex(key, min, max, limit: nil)
					if limit
						arguments = ["LIMIT", *limit]
					end
					
					call("ZRANGEBYLEX", key, min, max, *arguments)
				end
				
				# Return a range of members in a sorted set, by lexicographical range, ordered from higher to lower strings. O(log(N)+M) with N being the number of elements in the sorted set and M the number of elements being returned. If M is constant (e.g. always asking for the first 10 elements with LIMIT), you can consider it O(log(N)).
				# See <https://redis.io/commands/zrevrangebylex> for more details.
				# @parameter key [Key]
				# @parameter max [String]
				# @parameter min [String]
				def zrevrangebylex(key, min, max, limit: nil)
					if limit
						arguments = ["LIMIT", *limit]
					end
					
					call("ZREVRANGEBYLEX", key, min, max, *arguments)
				end
				
				# Return a range of members in a sorted set, by score. O(log(N)+M) with N being the number of elements in the sorted set and M the number of elements being returned. If M is constant (e.g. always asking for the first 10 elements with LIMIT), you can consider it O(log(N)).
				# See <https://redis.io/commands/zrangebyscore> for more details.
				# @parameter key [Key]
				# @parameter min [Integer]
				# @parameter max [Integer]
				# @parameter with_scores [Boolean] Return the scores of the elements together with the elements.
				# @parameter limit [Tuple<offset, count>] Limit the results to the specified `offset` and `count` items.
				#
				# @example Retrieve the first 10 members with score `>= 0` and `<= 100`
				# 	redis.zrangebyscore("zset", "0", "100", limit: [0, 10])
				def zrangebyscore(key, min, max, with_scores: false, limit: nil)
					arguments = [min, max]
					
					arguments.push("WITHSCORES") if with_scores
					arguments.push("LIMIT", *limit) if limit
					
					call("ZRANGEBYSCORE", key, *arguments)
				end
				
				# Determine the index of a member in a sorted set. O(log(N)).
				# See <https://redis.io/commands/zrank> for more details.
				# @parameter key [Key]
				# @parameter member [String]
				def zrank(key, member)
					call("ZRANK", key, member)
				end
				
				# Remove one or more members from a sorted set. O(M*log(N)) with N being the number of elements in the sorted set and M the number of elements to be removed.
				# See <https://redis.io/commands/zrem> for more details.
				# @parameter key [Key]
				# @parameter member [String]
				def zrem(key, member)
					call("ZREM", key, member)
				end
				
				# Remove all members in a sorted set between the given lexicographical range. O(log(N)+M) with N being the number of elements in the sorted set and M the number of elements removed by the operation.
				# See <https://redis.io/commands/zremrangebylex> for more details.
				# @parameter key [Key]
				# @parameter min [String]
				# @parameter max [String]
				def zremrangebylex(key, min, max)
					call("ZREMRANGEBYLEX", key, min, max)
				end
				
				# Remove all members in a sorted set within the given indexes. O(log(N)+M) with N being the number of elements in the sorted set and M the number of elements removed by the operation.
				# See <https://redis.io/commands/zremrangebyrank> for more details.
				# @parameter key [Key]
				# @parameter start [Integer]
				# @parameter stop [Integer]
				def zremrangebyrank(key, start, stop)
					call("ZREMRANGEBYRANK", key, start, stop)
				end
				
				# Remove all members in a sorted set within the given scores. O(log(N)+M) with N being the number of elements in the sorted set and M the number of elements removed by the operation.
				# See <https://redis.io/commands/zremrangebyscore> for more details.
				# @parameter key [Key]
				# @parameter min [Double]
				# @parameter max [Double]
				def zremrangebyscore(key, min, max)
					call("ZREMRANGEBYSCORE", key, min, max)
				end
				
				# Return a range of members in a sorted set, by index, with scores ordered from high to low. O(log(N)+M) with N being the number of elements in the sorted set and M the number of elements returned.
				# See <https://redis.io/commands/zrevrange> for more details.
				# @parameter key [Key]
				# @parameter start [Integer]
				# @parameter stop [Integer]
				# @parameter withscores [Enum]
				def zrevrange(key, min, max, with_scores: false)
					arguments = [min, max]
					
					arguments.push("WITHSCORES") if with_scores
					
					call("ZREVRANGE", key, *arguments)
				end
				
				# Return a range of members in a sorted set, by score, with scores ordered from high to low. O(log(N)+M) with N being the number of elements in the sorted set and M the number of elements being returned. If M is constant (e.g. always asking for the first 10 elements with LIMIT), you can consider it O(log(N)).
				# See <https://redis.io/commands/zrevrangebyscore> for more details.
				# @parameter key [Key]
				# @parameter max [Double]
				# @parameter min [Double]
				# @parameter withscores [Enum]
				def zrevrangebyscore(key, min, max, with_scores: false, limit: nil)
					arguments = [min, max]
					
					arguments.push("WITHSCORES") if with_scores
					arguments.push("LIMIT", *limit) if limit
					
					call("ZREVRANGEBYSCORE", key, *arguments)
				end
				
				# Determine the index of a member in a sorted set, with scores ordered from high to low. O(log(N)).
				# See <https://redis.io/commands/zrevrank> for more details.
				# @parameter key [Key]
				# @parameter member [String]
				def zrevrank(key, member)
					call("ZREVRANK", key, member)
				end
				
				# Get the score associated with the given member in a sorted set. O(1).
				# See <https://redis.io/commands/zscore> for more details.
				# @parameter key [Key]
				# @parameter member [String]
				def zscore(key, member)
					call("ZSCORE", key, member)
				end
				
				# Add multiple sorted sets and store the resulting sorted set in a new key. O(N)+O(M log(M)) with N being the sum of the sizes of the input sorted sets, and M being the number of elements in the resulting sorted set.
				# See <https://redis.io/commands/zunionstore> for more details.
				# @parameter destination [Key]
				# @parameter numkeys [Integer]
				# @parameter key [Key]
				def zunionstore(*arguments)
					call("ZUNIONSTORE", *arguments)
				end
				
				# Incrementally iterate sorted sets elements and associated scores. O(1) for every call. O(N) for a complete iteration, including enough command calls for the cursor to return back to 0. N is the number of elements inside the collection..
				# See <https://redis.io/commands/zscan> for more details.
				# @parameter key [Key]
				# @parameter cursor [Integer]
				def zscan(key, cursor = 0, match: nil, count: nil)
					arguments = [key, cursor]
					
					if match
						arguments.push("MATCH", match)
					end
					
					if count
						arguments.push("COUNT", count)
					end
					
					call("ZSCAN", *arguments)
				end
			end
		end
	end
end
