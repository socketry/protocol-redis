# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2019-2023, by Samuel Williams.
# Copyright, 2020, by Dimitry Chopey.
# Copyright, 2021, by Daniel Evans.
# Copyright, 2023, by Nick Burwell.

require_relative 'methods/generic'
require_relative 'methods/connection'
require_relative 'methods/server'
require_relative 'methods/geospatial'

require_relative 'methods/counting'

require_relative 'methods/hashes'
require_relative 'methods/lists'
require_relative 'methods/scripting'
require_relative 'methods/sets'
require_relative 'methods/strings'
require_relative 'methods/streams'
require_relative 'methods/sorted_sets'

require_relative 'methods/pubsub'

module Protocol
	module Redis
		module Methods
			def self.included(klass)
				klass.include Methods::Generic
				klass.include Methods::Connection
				klass.include Methods::Server
				klass.include Methods::Geospatial
				
				klass.include Methods::Counting
				
				klass.include Methods::Hashes
				klass.include Methods::Lists
				klass.include Methods::Scripting
				klass.include Methods::Sets
				klass.include Methods::SortedSets
				klass.include Methods::Strings
				klass.include Methods::Streams
				
				klass.include Methods::Pubsub
			end
		end
	end
end
