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
			module Streams
				# Get information on streams and consumer groups. O(N) with N being the number of returned items for the subcommands CONSUMERS and GROUPS. The STREAM subcommand is O(log N) with N being the number of items in the stream.
				# @see https://redis.io/commands/xinfo
				# @param help [Enum]
				def xinfo(*arguments)
					call("XINFO", *arguments)
				end
				
				# Appends a new entry to a stream. O(1).
				# @see https://redis.io/commands/xadd
				# @param key [Key]
				# @param ID [String]
				def xadd(*arguments)
					call("XADD", *arguments)
				end
				
				# Trims the stream to (approximately if '~' is passed) a certain size. O(N), with N being the number of evicted entries. Constant times are very small however, since entries are organized in macro nodes containing multiple entries that can be released with a single deallocation.
				# @see https://redis.io/commands/xtrim
				# @param key [Key]
				# @param strategy [Enum]
				# @param approx [Enum]
				# @param count [Integer]
				def xtrim(*arguments)
					call("XTRIM", *arguments)
				end
				
				# Removes the specified entries from the stream. Returns the number of items actually deleted, that may be different from the number of IDs passed in case certain IDs do not exist. O(1) for each single item to delete in the stream, regardless of the stream size.
				# @see https://redis.io/commands/xdel
				# @param key [Key]
				# @param ID [String]
				def xdel(*arguments)
					call("XDEL", *arguments)
				end
				
				# Return a range of elements in a stream, with IDs matching the specified IDs interval. O(N) with N being the number of elements being returned. If N is constant (e.g. always asking for the first 10 elements with COUNT), you can consider it O(1).
				# @see https://redis.io/commands/xrange
				# @param key [Key]
				# @param start [String]
				# @param end [String]
				def xrange(*arguments)
					call("XRANGE", *arguments)
				end
				
				# Return a range of elements in a stream, with IDs matching the specified IDs interval, in reverse order (from greater to smaller IDs) compared to XRANGE. O(N) with N being the number of elements returned. If N is constant (e.g. always asking for the first 10 elements with COUNT), you can consider it O(1).
				# @see https://redis.io/commands/xrevrange
				# @param key [Key]
				# @param end [String]
				# @param start [String]
				def xrevrange(*arguments)
					call("XREVRANGE", *arguments)
				end
				
				# Return the number of entires in a stream. O(1).
				# @see https://redis.io/commands/xlen
				# @param key [Key]
				def xlen(*arguments)
					call("XLEN", *arguments)
				end
				
				# Return never seen elements in multiple streams, with IDs greater than the ones reported by the caller for each stream. Can block. For each stream mentioned: O(N) with N being the number of elements being returned, it means that XREAD-ing with a fixed COUNT is O(1). Note that when the BLOCK option is used, XADD will pay O(M) time in order to serve the M clients blocked on the stream getting new data.
				# @see https://redis.io/commands/xread
				# @param streams [Enum]
				# @param key [Key]
				# @param id [String]
				def xread(*arguments)
					call("XREAD", *arguments)
				end
				
				# Create, destroy, and manage consumer groups. O(1) for all the subcommands, with the exception of the DESTROY subcommand which takes an additional O(M) time in order to delete the M entries inside the consumer group pending entries list (PEL).
				# @see https://redis.io/commands/xgroup
				def xgroup(*arguments)
					call("XGROUP", *arguments)
				end
				
				# Return new entries from a stream using a consumer group, or access the history of the pending entries for a given consumer. Can block. For each stream mentioned: O(M) with M being the number of elements returned. If M is constant (e.g. always asking for the first 10 elements with COUNT), you can consider it O(1). On the other side when XREADGROUP blocks, XADD will pay the O(N) time in order to serve the N clients blocked on the stream getting new data.
				# @see https://redis.io/commands/xreadgroup
				# @param noack [Enum]
				# @param streams [Enum]
				# @param key [Key]
				# @param ID [String]
				def xreadgroup(*arguments)
					call("XREADGROUP", *arguments)
				end
				
				# Marks a pending message as correctly processed, effectively removing it from the pending entries list of the consumer group. Return value of the command is the number of messages successfully acknowledged, that is, the IDs we were actually able to resolve in the PEL. O(1) for each message ID processed.
				# @see https://redis.io/commands/xack
				# @param key [Key]
				# @param group [String]
				# @param ID [String]
				def xack(*arguments)
					call("XACK", *arguments)
				end
				
				# Changes (or acquires) ownership of a message in a consumer group, as if the message was delivered to the specified consumer. O(log N) with N being the number of messages in the PEL of the consumer group.
				# @see https://redis.io/commands/xclaim
				# @param key [Key]
				# @param group [String]
				# @param consumer [String]
				# @param min-idle-time [String]
				# @param ID [String]
				def xclaim(*arguments)
					call("XCLAIM", *arguments)
				end
				
				# Return information and entries from a stream consumer group pending entries list, that are messages fetched but never acknowledged. O(N) with N being the number of elements returned, so asking for a small fixed number of entries per call is O(1). When the command returns just the summary it runs in O(1) time assuming the list of consumers is small, otherwise there is additional O(N) time needed to iterate every consumer.
				# @see https://redis.io/commands/xpending
				# @param key [Key]
				# @param group [String]
				# @param consumer [String]
				def xpending(*arguments)
					call("XPENDING", *arguments)
				end
			end
		end
	end
end
