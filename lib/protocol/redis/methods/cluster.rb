# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2023, by Nick Burwell.

module Protocol
	module Redis
		module Methods
			module Cluster
				# Sends the `CLUSTER *` command to random node and returns its reply.
				# @see https://redis.io/commands/cluster-addslots/
				# @param subcommand [String, Symbol] the subcommand of cluster command
				#   e.g. `:addslots`, `:delslots`, `:nodes`, `:replicas`, `:info`
				#
				# @return [Object] depends on the subcommand provided
				def cluster(subcommand, *args)
					call("CLUSTER", subcommand.to_s, *args)
				end
				
				# Sends `ASKING` command to random node and returns its reply.
				# @see https://redis.io/commands/asking/
				#
				# @return [String] `'OK'`
				def asking
					call("ASKING")
				end
			end
		end
	end
end
