# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2020-2025, by Samuel Williams.
# Copyright, 2023, by Nick Burwell.

module Protocol
	module Redis
		module Methods
			# Methods for managing Redis scripting.
			module Scripting
				# Execute a Lua script server side.
				# @parameter script [String] The Lua script to execute.
				# @parameter key_count [Integer] Number of keys that follow.
				# @parameter keys_and_args [Array] Keys followed by arguments to the script.
				# @returns [Object] The result of the script execution.
				def eval(script, key_count = 0, *keys_and_args)
					call("EVAL", script, key_count, *keys_and_args)
				end
				
				# Execute a cached Lua script by SHA1 digest.
				# @parameter sha1 [String] The SHA1 digest of the script to execute.
				# @parameter key_count [Integer] Number of keys that follow.
				# @parameter keys_and_args [Array] Keys followed by arguments to the script.
				# @returns [Object] The result of the script execution.
				def evalsha(sha1, key_count = 0, *keys_and_args)
					call("EVALSHA", sha1, key_count, *keys_and_args)
				end
				
				# Execute script management commands.
				# @parameter subcommand [String|Symbol] The script subcommand (debug, exists, flush, load, kill).
				# @parameter arguments [Array] Additional arguments for the subcommand.
				# @returns [Object] The result of the script command.
				def script(subcommand, *arguments)
					call("SCRIPT", subcommand.to_s, *arguments)
				end
			end
		end
	end
end
