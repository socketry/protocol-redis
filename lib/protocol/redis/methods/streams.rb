# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2020-2023, by Samuel Williams.

module Protocol
	module Redis
		module Methods
			# Methods for managing Redis streams.
			module Streams
				# Get information on streams and consumer groups. O(N) with N being the number of returned items for the subcommands CONSUMERS and GROUPS. The STREAM subcommand is O(log N) with N being the number of items in the stream.
				# See <https://redis.io/commands/xinfo> for more details.
				# @parameter help [Enum]
				def xinfo(*arguments)
					call("XINFO", *arguments)
				end
				
				# Appends a new entry to a stream. O(1).
				# See <https://redis.io/commands/xadd> for more details.
				# @parameter key [Key]
				# @parameter ID [String]
				def xadd(*arguments)
					call("XADD", *arguments)
				end
				
				# Trims the stream to (approximately if '~' is passed) a certain size. O(N), with N being the number of evicted entries. Constant times are very small however, since entries are organized in macro nodes containing multiple entries that can be released with a single deallocation.
				# See <https://redis.io/commands/xtrim> for more details.
				# @parameter key [Key]
				# @parameter strategy [Enum]
				# @parameter approx [Enum]
				# @parameter count [Integer]
				def xtrim(*arguments)
					call("XTRIM", *arguments)
				end
				
				# Removes the specified entries from the stream. Returns the number of items actually deleted, that may be different from the number of IDs passed in case certain IDs do not exist. O(1) for each single item to delete in the stream, regardless of the stream size.
				# See <https://redis.io/commands/xdel> for more details.
				# @parameter key [Key]
				# @parameter ID [String]
				def xdel(*arguments)
					call("XDEL", *arguments)
				end
				
				# Return a range of elements in a stream, with IDs matching the specified IDs interval. O(N) with N being the number of elements being returned. If N is constant (e.g. always asking for the first 10 elements with COUNT), you can consider it O(1).
				# See <https://redis.io/commands/xrange> for more details.
				# @parameter key [Key]
				# @parameter start [String]
				# @parameter end [String]
				def xrange(*arguments)
					call("XRANGE", *arguments)
				end
				
				# Return a range of elements in a stream, with IDs matching the specified IDs interval, in reverse order (from greater to smaller IDs) compared to XRANGE. O(N) with N being the number of elements returned. If N is constant (e.g. always asking for the first 10 elements with COUNT), you can consider it O(1).
				# See <https://redis.io/commands/xrevrange> for more details.
				# @parameter key [Key]
				# @parameter end [String]
				# @parameter start [String]
				def xrevrange(*arguments)
					call("XREVRANGE", *arguments)
				end
				
				# Return the number of entires in a stream. O(1).
				# See <https://redis.io/commands/xlen> for more details.
				# @parameter key [Key]
				def xlen(*arguments)
					call("XLEN", *arguments)
				end
				
				# Return never seen elements in multiple streams, with IDs greater than the ones reported by the caller for each stream. Can block. For each stream mentioned: O(N) with N being the number of elements being returned, it means that XREAD-ing with a fixed COUNT is O(1). Note that when the BLOCK option is used, XADD will pay O(M) time in order to serve the M clients blocked on the stream getting new data.
				# See <https://redis.io/commands/xread> for more details.
				# @parameter streams [Enum]
				# @parameter key [Key]
				# @parameter id [String]
				def xread(*arguments)
					call("XREAD", *arguments)
				end
				
				# Create, destroy, and manage consumer groups. O(1) for all the subcommands, with the exception of the DESTROY subcommand which takes an additional O(M) time in order to delete the M entries inside the consumer group pending entries list (PEL).
				# See <https://redis.io/commands/xgroup> for more details.
				def xgroup(*arguments)
					call("XGROUP", *arguments)
				end
				
				# Return new entries from a stream using a consumer group, or access the history of the pending entries for a given consumer. Can block. For each stream mentioned: O(M) with M being the number of elements returned. If M is constant (e.g. always asking for the first 10 elements with COUNT), you can consider it O(1). On the other side when XREADGROUP blocks, XADD will pay the O(N) time in order to serve the N clients blocked on the stream getting new data.
				# See <https://redis.io/commands/xreadgroup> for more details.
				# @parameter noack [Enum]
				# @parameter streams [Enum]
				# @parameter key [Key]
				# @parameter ID [String]
				def xreadgroup(*arguments)
					call("XREADGROUP", *arguments)
				end
				
				# Marks a pending message as correctly processed, effectively removing it from the pending entries list of the consumer group. Return value of the command is the number of messages successfully acknowledged, that is, the IDs we were actually able to resolve in the PEL. O(1) for each message ID processed.
				# See <https://redis.io/commands/xack> for more details.
				# @parameter key [Key]
				# @parameter group [String]
				# @parameter ID [String]
				def xack(*arguments)
					call("XACK", *arguments)
				end
				
				# Changes (or acquires) ownership of a message in a consumer group, as if the message was delivered to the specified consumer. O(log N) with N being the number of messages in the PEL of the consumer group.
				# See <https://redis.io/commands/xclaim> for more details.
				# @parameter key [Key]
				# @parameter group [String]
				# @parameter consumer [String]
				# @parameter min-idle-time [String]
				# @parameter ID [String]
				def xclaim(*arguments)
					call("XCLAIM", *arguments)
				end
				
				# Return information and entries from a stream consumer group pending entries list, that are messages fetched but never acknowledged. O(N) with N being the number of elements returned, so asking for a small fixed number of entries per call is O(1). When the command returns just the summary it runs in O(1) time assuming the list of consumers is small, otherwise there is additional O(N) time needed to iterate every consumer.
				# See <https://redis.io/commands/xpending> for more details.
				# @parameter key [Key]
				# @parameter group [String]
				# @parameter consumer [String]
				def xpending(*arguments)
					call("XPENDING", *arguments)
				end
			end
		end
	end
end
