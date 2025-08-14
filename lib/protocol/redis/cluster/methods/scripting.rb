# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2023, by Samuel Williams.

module Protocol
	module Redis
		module Cluster
			module Methods
				# Methods for managing Redis scripting in cluster environments.
				# 
				# Scripting operations in Redis clusters require careful consideration of key distribution.
				# EVAL and EVALSHA operations are routed based on the keys they access, while SCRIPT
				# management commands may need to be executed on specific nodes or all nodes.
				module Scripting
					# Execute a Lua script server side in a cluster environment.
					# 
					# The script will be executed on the node determined by the first key's slot.
					# Redis will return a CROSSSLOT error if keys span multiple slots.
					# 
					# @parameter script [String] The Lua script to execute.
					# @parameter key_count [Integer] Number of keys that follow.
					# @parameter keys [Array[String]] The keys the script will access.
					# @parameter args [Array[String]] Additional arguments to the script.
					# @parameter role [Symbol] The role of the cluster node (:master or :slave).
					# @returns [Object] The result of the script execution.
					def eval(script, key_count = 0, *keys_and_args, role: :master)
						if key_count == 0
							# No keys, can execute on any client
							any_client(role).call("EVAL", script, key_count, *keys_and_args)
						else
							# Extract keys for routing
							keys = keys_and_args[0, key_count]
							args = keys_and_args[key_count..-1] || []
							
							# Route to appropriate cluster node based on first key
							# Redis will handle CROSSSLOT validation
							slot = slot_for(keys.first)
							client_for(slot, role).call("EVAL", script, key_count, *keys, *args)
						end
					end
					
					# Execute a cached Lua script by SHA1 digest in a cluster environment.
					# 
					# The script will be executed on the node determined by the first key's slot.
					# Redis will return a CROSSSLOT error if keys span multiple slots.
					# The script must already be loaded on the target node via SCRIPT LOAD.
					# 
					# @parameter sha1 [String] The SHA1 digest of the script to execute.
					# @parameter key_count [Integer] Number of keys that follow.
					# @parameter keys [Array[String]] The keys the script will access.
					# @parameter args [Array[String]] Additional arguments to the script.
					# @parameter role [Symbol] The role of the cluster node (:master or :slave).
					# @returns [Object] The result of the script execution.
					def evalsha(sha1, key_count = 0, *keys_and_args, role: :master)
						if key_count == 0
							# No keys, can execute on any client
							any_client(role).call("EVALSHA", sha1, key_count, *keys_and_args)
						else
							# Extract keys for routing
							keys = keys_and_args[0, key_count]
							args = keys_and_args[key_count..-1] || []
							
							# Route to appropriate cluster node based on first key
							# Redis will handle CROSSSLOT validation
							slot = slot_for(keys.first)
							client_for(slot, role).call("EVALSHA", sha1, key_count, *keys, *args)
						end
					end
					
					# Execute script management commands in a cluster environment.
					# 
					# Supported script subcommands:
					# - DEBUG: Set the debug mode for executed scripts on the target node.
					# - EXISTS: Check if scripts exist in the script cache on the target node.
					# - FLUSH: Remove all scripts from the script cache (propagates cluster-wide when executed on master).
					# - KILL: Kill the currently executing script on the target node.
					# - LOAD: Load a script into the script cache (propagates cluster-wide when executed on master).
					#
					# It is unlikely that DEBUG, EXISTS and KILL are useful when run on a cluster node at random.
					#
					# @parameter subcommand [String|Symbol] The script subcommand (debug, exists, flush, load, kill).
					# @parameter arguments [Array] Additional arguments for the subcommand.
					# @parameter role [Symbol] The role of the cluster node (:master or :slave).
					# @returns [Object] The result of the script command.
					def script(subcommand, *arguments, role: :master)
						any_client(role).call("SCRIPT", subcommand.to_s, *arguments)
					end
				end
			end
		end
	end
end
