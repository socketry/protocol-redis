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
