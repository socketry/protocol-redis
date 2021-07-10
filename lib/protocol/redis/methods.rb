# frozen_string_literal: true

# Copyright, 2019, by Mikael Henriksson. <http://www.mhenrixon.com>
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

require_relative 'methods/generic'
require_relative 'methods/connection'
require_relative 'methods/server'
require_relative 'methods/geospatial'

require_relative 'methods/counting'

require_relative 'methods/hashes'
require_relative 'methods/lists'
require_relative 'methods/strings'
require_relative 'methods/sets'
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
				klass.include Methods::Sets
				klass.include Methods::SortedSets
				klass.include Methods::Strings
				
				klass.include Methods::Pubsub
			end
		end
	end
end