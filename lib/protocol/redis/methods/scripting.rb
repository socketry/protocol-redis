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
				# @param key [Key] Multiple keys are supported, as long as the same number of values are also provided
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
				
				# Execute script management commands
				# @see https://redis.io/commands/script/
				# @param subcommand [String] e.g. `debug`, `exists`, `flush`, `load`, `kill`
				# @param [Array<String>] args depends on the subcommand provided
				def script(subcommand, *arguments)
					call("SCRIPT", subcommand.to_s, *arguments)
				end
			end
		end
	end
end
