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
			module Geospatial
				# Add one or more geospatial items in the geospatial index represented using a sorted set. O(log(N)) for each item added, where N is the number of elements in the sorted set.
				# @see https://redis.io/commands/geoadd
				# @param key [Key]
				def geoadd(key, longitude, latitude, member, *arguments)
					call("GEOADD", longitude, latitude, member, *arguments)
				end
				
				# Returns members of a geospatial index as standard geohash strings. O(log(N)) for each member requested, where N is the number of elements in the sorted set.
				# @see https://redis.io/commands/geohash
				# @param key [Key]
				# @param member [String]
				def geohash(key, member, *members)
					call("GEOHASH", key, member, *members)
				end
				
				# Returns longitude and latitude of members of a geospatial index. O(log(N)) for each member requested, where N is the number of elements in the sorted set.
				# @see https://redis.io/commands/geopos
				# @param key [Key]
				# @param member [String]
				def geopos(key, member, *members)
					call("GEOPOS", key, member, *members)
				end
				
				# Returns the distance between two members of a geospatial index. O(log(N)).
				# @see https://redis.io/commands/geodist
				# @param key [Key]
				# @param member1 [String]
				# @param member2 [String]
				# @param unit [Enum] Distance scale to use, one of "m" (meters), "km" (kilometers), "mi" (miles) or "ft" (feet).
				def geodist(key, from, to, unit = "m")
					call("GEODIST", key, from, to, unit)
				end
				
				# Query a sorted set representing a geospatial index to fetch members matching a given maximum distance from a point. O(N+log(M)) where N is the number of elements inside the bounding box of the circular area delimited by center and radius and M is the number of items inside the index.
				# @see https://redis.io/commands/georadius
				# @param key [Key]
				# @param longitude [Double]
				# @param latitude [Double]
				# @param radius [Double]
				# @param unit [Enum]
				# @param withcoord [Enum]
				# @param withdist [Enum]
				# @param withhash [Enum]
				def georadius(key, longitude, latitude, radius, unit = "m", withcoord: false, withdist: false, withhash: false, count: nil, store: nil, storedist: nil)
					arguments = [key, longitude, latitude, radius, unit]
					
					if withcoord
						arguments.append("WITHCOORD")
					end
					
					if withdist
						arguments.append("WITHDIST")
					end
					
					if withhash
						arguments.append("WITHHASH")
					end
					
					if count
						arguments.append("COUNT", count)
					end
					
					if store
						arguments.append("STORE", store)
					end
					
					if storedist
						arguments.append("STOREDIST", storedist)
					end
					
					call("GEORADIUS", *arguments)
				end
				
				# Query a sorted set representing a geospatial index to fetch members matching a given maximum distance from a member. O(N+log(M)) where N is the number of elements inside the bounding box of the circular area delimited by center and radius and M is the number of items inside the index.
				# @see https://redis.io/commands/georadiusbymember
				# @param key [Key]
				# @param member [String]
				# @param radius [Double]
				# @param unit [Enum]
				# @param withcoord [Enum]
				# @param withdist [Enum]
				# @param withhash [Enum]
				# @param order [Enum]
				def georadiusbymember(key, member, radius, unit = "m", withcoord: false, withdist: false, withhash: false, count: nil, store: nil, storedist: nil)
					arguments = [key, member, radius, unit]
					
					if withcoord
						arguments.append("WITHCOORD")
					end
					
					if withdist
						arguments.append("WITHDIST")
					end
					
					if withhash
						arguments.append("WITHHASH")
					end
					
					if count
						arguments.append("COUNT", count)
					end
					
					if store
						arguments.append("STORE", store)
					end
					
					if storedist
						arguments.append("STOREDIST", storedist)
					end
					
					call("GEORADIUS", *arguments)
				end
			end
		end
	end
end
