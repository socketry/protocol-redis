# frozen_string_literal: true

# Copyright, 2020, by Dimitry Chopey.
# Copyright, 2020, by Samuel G. D. Williams. <http://www.codeotaku.com>
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

				# Return a range of members in a sorted set, by score. O(log(N)+M) with N being the number of elements in the sorted set and M the number of elements being returned. If M is constant (e.g. always asking for the first 10 elements with LIMIT), you can consider it O(log(N))..
        # @see https://redis.io/commands/zrangebyscore
        # @param key [Key]
        # @param min [Integer]
        # @param max [Integer]
        # @param with_scores [Boolean] Return the scores of the elements together with the elements.
        # @param limit [Array] Can be used to only get a range of the matching elements (similar to SELECT LIMIT offset, count in SQL).
        # @example Retrieve the first 10 members with score `>= 0` and `<= 100`
        #   redis.zrangebyscore("zset", "0", "100", :limit => [0, 10])
        def zrangebyscore(key, min, max, with_scores: false, limit: nil)
          arguments = [min, max]

          arguments.push('WITHSCORES') if with_scores
          arguments.push('LIMIT', *limit) if limit

          call('ZRANGEBYSCORE', key, *arguments)
        end
				
				# Remove one or more members from a sorted set. O(M*log(N)) with N being the number of elements in the sorted set and M the number of elements to be removed.
				# @see https://redis.io/commands/zrem
				# @param key [Key]
				# @param member [String]
				def zrem(key, member)
					call("ZREM", key, member)
				end
			end
		end
	end
end
