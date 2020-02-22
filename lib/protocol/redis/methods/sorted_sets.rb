# frozen_string_literal: true

# Copyright, 2018, by Samuel G. D. Williams. <http://www.codeotaku.com>
# Copyright, 2020, by Dimitry Chopey.
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
			module SortedSets
				# Remove and return the member with the lowest score from one or more sorted sets, or block until one is available. O(log(N)) with N being the number of elements in the sorted set.
				# @see https://redis.io/commands/bzpopmin
				# @param key [Key]
				# @param timeout [Integer]
				def bzpopmin(*keys, timeout: 0)
					call("BZPOPMIN", *keys, timeout)
				end
				
				# Remove and return the member with the highest score from one or more sorted sets, or block until one is available. O(log(N)) with N being the number of elements in the sorted set.
				# @see https://redis.io/commands/bzpopmax
				# @param key [Key]
				# @param timeout [Integer]
				def bzpopmax(*keys, timeout: 0)
					call("BZPOPMAX", *keys, timeout: 0)
				end
				
				# Add one or more members to a sorted set, or update its score if it already exists. O(log(N)) for each item added, where N is the number of elements in the sorted set.
				# @see https://redis.io/commands/zadd
				# @param key [Key]
				# @param score [Double]
				# @param member [String]
				# @param others [Array] an array of `score`, `member` elements.
				# @param update [Boolean, nil] If true, only update elements that already exist (never add elements). If false, don't update existing elements (only add new elements).
				# @param change [Boolean] Modify the return value from the number of new elements added,
				#   to the total number of elements changed; changed elements are new elements added
				#   and elements already existing for which the score was updated.
				# @param increment [Boolean] When this option is specified ZADD acts like ZINCRBY;
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
				# @see https://redis.io/commands/zcard
				# @param key [Key]
				def zcard(key)
					call("ZCARD", key)
				end
				
				# Count the members in a sorted set with scores within the given values. O(log(N)) with N being the number of elements in the sorted set.
				# @see https://redis.io/commands/zcount
				# @param key [Key]
				# @param min [Double]
				# @param max [Double]
				def zcount(key, min, max)
					call("ZCOUNT", key, min, max)
				end
				
				# Increment the score of a member in a sorted set. O(log(N)) where N is the number of elements in the sorted set.
				# @see https://redis.io/commands/zincrby
				# @param key [Key]
				# @param increment [Integer]
				# @param member [String]
				def zincrby(key, increment, member)
					call("ZINCRBY", key, amount, member)
				end
				
				# Intersect multiple sorted sets and store the resulting sorted set in a new key. O(N*K)+O(M*log(M)) worst case with N being the smallest input sorted set, K being the number of input sorted sets and M being the number of elements in the resulting sorted set.
				# @see https://redis.io/commands/zinterstore
				# @param destination [Key]
				# @param keys [Array<Key>]
				# @param weights [Array<Integer>]
				# @param aggregate [Enum] one of sum, min, max.
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
				# @see https://redis.io/commands/zlexcount
				# @param key [Key]
				# @param min [String]
				# @param max [String]
				def zlexcount(key, min, max)
					call("ZLEXCOUNT", key, min, max)
				end
				
				# Remove and return members with the highest scores in a sorted set. O(log(N)*M) with N being the number of elements in the sorted set, and M being the number of elements popped.
				# @see https://redis.io/commands/zpopmax
				# @param key [Key]
				# @param count [Integer]
				def zpopmax(key, count = 1)
					call("ZPOPMAX", key, count)
				end
				
				# Remove and return members with the lowest scores in a sorted set. O(log(N)*M) with N being the number of elements in the sorted set, and M being the number of elements popped.
				# @see https://redis.io/commands/zpopmin
				# @param key [Key]
				# @param count [Integer]
				def zpopmin(key, count = 1)
					call("ZPOPMIN", key, count = 1)
				end
				
				# Return a range of members in a sorted set, by index. O(log(N)+M) with N being the number of elements in the sorted set and M the number of elements returned.
				# @see https://redis.io/commands/zrange
				# @param key [Key]
				# @param start [Integer]
				# @param stop [Integer]
				# @param with_scores [Boolean] Return the scores of the elements together with the elements.
				def zrange(key, start, stop, with_scores: false)
					arguments = [start, stop]
					
					arguments.push("WITHSCORES") if with_scores
					
					call("ZRANGE", key, *arguments)
				end
				
				# Return a range of members in a sorted set, by lexicographical range. O(log(N)+M) with N being the number of elements in the sorted set and M the number of elements being returned. If M is constant (e.g. always asking for the first 10 elements with LIMIT), you can consider it O(log(N)).
				# @see https://redis.io/commands/zrangebylex
				# @param key [Key]
				# @param min [String]
				# @param max [String]
				# @param limit [Tuple<offset, count>] Limit the results to the specified `offset` and `count` items.
				def zrangebylex(key, min, max, limit: nil)
					if limit
						arguments = ["LIMIT", *limit]
					end
					
					call("ZRANGEBYLEX", key, min, max, *arguments)
				end
				
				# Return a range of members in a sorted set, by lexicographical range, ordered from higher to lower strings. O(log(N)+M) with N being the number of elements in the sorted set and M the number of elements being returned. If M is constant (e.g. always asking for the first 10 elements with LIMIT), you can consider it O(log(N)).
				# @see https://redis.io/commands/zrevrangebylex
				# @param key [Key]
				# @param max [String]
				# @param min [String]
				def zrevrangebylex(key, min, max, limit: nil)
					if limit
						arguments = ["LIMIT", *limit]
					end
					
					call("ZREVRANGEBYLEX", key, min, max, *arguments)
				end
				
				# Return a range of members in a sorted set, by score. O(log(N)+M) with N being the number of elements in the sorted set and M the number of elements being returned. If M is constant (e.g. always asking for the first 10 elements with LIMIT), you can consider it O(log(N)).
				# @see https://redis.io/commands/zrangebyscore
				# @param key [Key]
				# @param min [Integer]
				# @param max [Integer]
				# @param with_scores [Boolean] Return the scores of the elements together with the elements.
				# @param limit [Tuple<offset, count>] Limit the results to the specified `offset` and `count` items.
				#
				# @example Retrieve the first 10 members with score `>= 0` and `<= 100`
				# 	redis.zrangebyscore("zset", "0", "100", limit: [0, 10])
				def zrangebyscore(key, min, max, with_scores: false, limit: nil)
					arguments = [min, max]
					
					arguments.push('WITHSCORES') if with_scores
					arguments.push('LIMIT', *limit) if limit
					
					call('ZRANGEBYSCORE', key, *arguments)
				end
				
				# Determine the index of a member in a sorted set. O(log(N)).
				# @see https://redis.io/commands/zrank
				# @param key [Key]
				# @param member [String]
				def zrank(key, member)
					call("ZRANK", key, member)
				end
				
				# Remove one or more members from a sorted set. O(M*log(N)) with N being the number of elements in the sorted set and M the number of elements to be removed.
				# @see https://redis.io/commands/zrem
				# @param key [Key]
				# @param member [String]
				def zrem(key, member)
					call("ZREM", key, member)
				end
				
				# Remove all members in a sorted set between the given lexicographical range. O(log(N)+M) with N being the number of elements in the sorted set and M the number of elements removed by the operation.
				# @see https://redis.io/commands/zremrangebylex
				# @param key [Key]
				# @param min [String]
				# @param max [String]
				def zremrangebylex(key, min, max)
					call("ZREMRANGEBYLEX", key, min, max)
				end
				
				# Remove all members in a sorted set within the given indexes. O(log(N)+M) with N being the number of elements in the sorted set and M the number of elements removed by the operation.
				# @see https://redis.io/commands/zremrangebyrank
				# @param key [Key]
				# @param start [Integer]
				# @param stop [Integer]
				def zremrangebyrank(key, start, stop)
					call("ZREMRANGEBYRANK", key, start, stop)
				end
				
				# Remove all members in a sorted set within the given scores. O(log(N)+M) with N being the number of elements in the sorted set and M the number of elements removed by the operation.
				# @see https://redis.io/commands/zremrangebyscore
				# @param key [Key]
				# @param min [Double]
				# @param max [Double]
				def zremrangebyscore(key, min, max)
					call("ZREMRANGEBYSCORE", key, min, max)
				end
				
				# Return a range of members in a sorted set, by index, with scores ordered from high to low. O(log(N)+M) with N being the number of elements in the sorted set and M the number of elements returned.
				# @see https://redis.io/commands/zrevrange
				# @param key [Key]
				# @param start [Integer]
				# @param stop [Integer]
				# @param withscores [Enum]
				def zrevrange(key, min, max, with_scores: false)
					arguments = [min, max]
					
					arguments.push('WITHSCORES') if with_scores
					
					call("ZREVRANGE", key, *arguments)
				end
				
				# Return a range of members in a sorted set, by score, with scores ordered from high to low. O(log(N)+M) with N being the number of elements in the sorted set and M the number of elements being returned. If M is constant (e.g. always asking for the first 10 elements with LIMIT), you can consider it O(log(N)).
				# @see https://redis.io/commands/zrevrangebyscore
				# @param key [Key]
				# @param max [Double]
				# @param min [Double]
				# @param withscores [Enum]
				def zrevrangebyscore(key, min, max, with_scores: false, limit: nil)
					arguments = [min, max]
					
					arguments.push('WITHSCORES') if with_scores
					arguments.push('LIMIT', *limit) if limit
					
					call("ZREVRANGEBYSCORE", key, *arguments)
				end
				
				# Determine the index of a member in a sorted set, with scores ordered from high to low. O(log(N)).
				# @see https://redis.io/commands/zrevrank
				# @param key [Key]
				# @param member [String]
				def zrevrank(key, member)
					call("ZREVRANK", key, member)
				end
				
				# Get the score associated with the given member in a sorted set. O(1).
				# @see https://redis.io/commands/zscore
				# @param key [Key]
				# @param member [String]
				def zscore(key, member)
					call("ZSCORE", key, member)
				end
				
				# Add multiple sorted sets and store the resulting sorted set in a new key. O(N)+O(M log(M)) with N being the sum of the sizes of the input sorted sets, and M being the number of elements in the resulting sorted set.
				# @see https://redis.io/commands/zunionstore
				# @param destination [Key]
				# @param numkeys [Integer]
				# @param key [Key]
				def zunionstore(*arguments)
					call("ZUNIONSTORE", *arguments)
				end
				
				# Incrementally iterate sorted sets elements and associated scores. O(1) for every call. O(N) for a complete iteration, including enough command calls for the cursor to return back to 0. N is the number of elements inside the collection..
				# @see https://redis.io/commands/zscan
				# @param key [Key]
				# @param cursor [Integer]
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
