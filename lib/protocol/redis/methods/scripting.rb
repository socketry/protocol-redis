# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2020-2023, by Samuel Williams.
# Copyright, 2023, by Nick Burwell.

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
