# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2020-2023, by Samuel Williams.
# Copyright, 2023, by Nick Burwell.

module Protocol
	module Redis
		module Methods
			module Scripting
				# Execute a Lua script server side. Depends on the script that is executed.
				# See <https://redis.io/commands/eval> for more details.
				# @parameter script [String]
				# @parameter numkeys [Integer]
				# @parameter key [Key] Multiple keys are supported, as long as the same number of values are also provided
				# @parameter arg [String]
				def eval(*arguments)
					call("EVAL", *arguments)
				end
				
				# Execute a Lua script server side. Depends on the script that is executed.
				# See <https://redis.io/commands/evalsha> for more details.
				# @parameter sha1 [String]
				# @parameter numkeys [Integer]
				# @parameter key [Key]
				# @parameter arg [String]
				def evalsha(*arguments)
					call("EVALSHA", *arguments)
				end
				
				# Execute script management commands
				# See <https://redis.io/commands/script/> for more details.
				# @parameter subcommand [String] e.g. `debug`, `exists`, `flush`, `load`, `kill`
				# @parameter [Array<String>] args depends on the subcommand provided
				def script(subcommand, *arguments)
					call("SCRIPT", subcommand.to_s, *arguments)
				end
			end
		end
	end
end
