# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2023, by Nick Burwell.
# Copyright, 2024, by Samuel Williams.

module Protocol
	module Redis
		module Methods
			module Cluster
				# Sends the `CLUSTER *` command to random node and returns its reply.
				# See <https://redis.io/commands/cluster-addslots/> for more details.
				# @parameter subcommand [String, Symbol] the subcommand of cluster command
				#   e.g. `:addslots`, `:delslots`, `:nodes`, `:replicas`, `:info`
				#
				# @returns [Object] depends on the subcommand provided
				def cluster(subcommand, *args)
					call("CLUSTER", subcommand.to_s, *args)
				end
				
				# Sends `ASKING` command to random node and returns its reply.
				# See <https://redis.io/commands/asking/> for more details.
				#
				# @returns [String] `'OK'`
				def asking
					call("ASKING")
				end
			end
		end
	end
end
