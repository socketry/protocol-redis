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
			module SortedSets
				# Add one or more members to a sorted set, or update its score if it already exists. O(log(N)) for each item added, where N is the number of elements in the sorted set.
				# @see https://redis.io/commands/zadd
				# @param key [Key]
				# @param score [Double]
				# @param member [String]
				# @param condition [Enum]
				# @param change [Enum]
				# @param increment [Enum]
				def zadd(key, *args)
					zadd_options = []
					if args.last.is_a?(Hash)
						options = args.pop
					  zadd_options = ['NX', 'XX', 'CH', 'INCR'].select do |o|
					    options[o.downcase.to_sym]
						end
					end

					zadd_args = ["ZADD", key] + zadd_options

					if args.size == 1 && args[0].is_a?(Array)
						zadd_args = zadd_args + args[0].flatten
					elsif args.size == 2
						zadd_args = zadd_args + args
					else
						raise ArgumentError, "wrong number of arguments"
					end

					call(*zadd_args)
				end

				# Return a range of members in a sorted set, by index. O(log(N)+M) with N being the number of elements in the sorted set and M the number of elements returned.
				# @see https://redis.io/commands/zrange
				# @param key [Key]
				# @param start [Integer]
				# @param stop [Integer]
				# @param withscores [Enum]
				def zrange(key, start, stop, withscores: false)
					zrange_args = ["ZRANGE", key, start, stop]
					zrange_args << "WITHSCORES" if withscores

					call(*zrange_args)
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
