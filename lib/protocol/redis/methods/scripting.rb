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
			module Scripting
				# Execute a Lua script server side. Depends on the script that is executed.
				# @see https://redis.io/commands/eval
				# @param script [String]
				# @param numkeys [Integer]
				# @param key [Key]
				# @param arg [String]
				def eval(*arguments)
					call("EVAL", *arguments)
				end
				
				# Execute a Lua script server side. Depends on the script that is executed.
				# @see https://redis.io/commands/evalsha
				# @param sha1 [String]
				# @param numkeys [Integer]
				# @param key [Key]
				# @param arg [String]
				def evalsha(*arguments)
					call("EVALSHA", *arguments)
				end
				
				# Set the debug mode for executed scripts. O(1).
				# @see https://redis.io/commands/script debug
				# @param mode [Enum]
				def script_debug(*arguments)
					call("SCRIPT DEBUG", *arguments)
				end
				
				# Check existence of scripts in the script cache. O(N) with N being the number of scripts to check (so checking a single script is an O(1) operation).
				# @see https://redis.io/commands/script exists
				# @param sha1 [String]
				def script_exists(*arguments)
					call("SCRIPT EXISTS", *arguments)
				end
				
				# Remove all the scripts from the script cache. O(N) with N being the number of scripts in cache.
				# @see https://redis.io/commands/script flush
				def script_flush(*arguments)
					call("SCRIPT FLUSH", *arguments)
				end
				
				# Kill the script currently in execution. O(1).
				# @see https://redis.io/commands/script kill
				def script_kill(*arguments)
					call("SCRIPT KILL", *arguments)
				end
				
				# Load the specified Lua script into the script cache. O(N) with N being the length in bytes of the script body.
				# @see https://redis.io/commands/script load
				# @param script [String]
				def script_load(*arguments)
					call("SCRIPT LOAD", *arguments)
				end
			end
		end
	end
end
