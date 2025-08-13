# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2019-2023, by Samuel Williams.

module Protocol
	module Redis
		module Methods
			module Geospatial
				# Add one or more geospatial items in the geospatial index represented using a sorted set. O(log(N)) for each item added, where N is the number of elements in the sorted set.
				# See <https://redis.io/commands/geoadd> for more details.
				# @parameter key [Key]
				def geoadd(key, longitude, latitude, member, *arguments)
					call("GEOADD", longitude, latitude, member, *arguments)
				end
				
				# Returns members of a geospatial index as standard geohash strings. O(log(N)) for each member requested, where N is the number of elements in the sorted set.
				# See <https://redis.io/commands/geohash> for more details.
				# @parameter key [Key]
				# @parameter member [String]
				def geohash(key, member, *members)
					call("GEOHASH", key, member, *members)
				end
				
				# Returns longitude and latitude of members of a geospatial index. O(log(N)) for each member requested, where N is the number of elements in the sorted set.
				# See <https://redis.io/commands/geopos> for more details.
				# @parameter key [Key]
				# @parameter member [String]
				def geopos(key, member, *members)
					call("GEOPOS", key, member, *members)
				end
				
				# Returns the distance between two members of a geospatial index. O(log(N)).
				# See <https://redis.io/commands/geodist> for more details.
				# @parameter key [Key]
				# @parameter member1 [String]
				# @parameter member2 [String]
				# @parameter unit [Enum] Distance scale to use, one of "m" (meters), "km" (kilometers), "mi" (miles) or "ft" (feet).
				def geodist(key, from, to, unit = "m")
					call("GEODIST", key, from, to, unit)
				end
				
				# Query a sorted set representing a geospatial index to fetch members matching a given maximum distance from a point. O(N+log(M)) where N is the number of elements inside the bounding box of the circular area delimited by center and radius and M is the number of items inside the index.
				# See <https://redis.io/commands/georadius> for more details.
				# @parameter key [Key]
				# @parameter longitude [Double]
				# @parameter latitude [Double]
				# @parameter radius [Double]
				# @parameter unit [Enum]
				# @parameter count [Integer] Limit the number of results to at most this many.
				# @parameter order [Symbol] `:ASC` Sort returned items from the nearest to the farthest, relative to the center. `:DESC` Sort returned items from the farthest to the nearest, relative to the center.
				# @parameter with_coordinates [Boolean] Also return the longitude,latitude coordinates of the matching items.
				# @parameter with_distance [Boolean] Also return the distance of the returned items from the specified center. The distance is returned in the same unit as the unit specified as the radius argument of the command.
				# @parameter with_hash [Boolean] Also return the raw geohash-encoded sorted set score of the item, in the form of a 52 bit unsigned integer. This is only useful for low level hacks or debugging and is otherwise of little interest for the general user.
				# @parameter store [Key]
				# @parameter store_distance [Key]
				def georadius(key, longitude, latitude, radius, unit = "m", with_coordinates: false, with_distance: false, with_hash: false, count: nil, order: nil, store: nil, store_distance: nil)
					arguments = [key, longitude, latitude, radius, unit]
					
					if with_coordinates
						arguments.append("WITHCOORD")
					end
					
					if with_distance
						arguments.append("WITHDIST")
					end
					
					if with_hash
						arguments.append("WITHHASH")
					end
					
					if count
						arguments.append("COUNT", count)
					end
					
					if order
						arguments.append(order)
					end
					
					readonly = true
					
					if store
						arguments.append("STORE", store)
						readonly = false
					end
					
					if store_distance
						arguments.append("STOREDIST", storedist)
						readonly = false
					end
					
					# https://redis.io/commands/georadius#read-only-variants
					if readonly
						call("GEORADIUS_RO", *arguments)
					else
						call("GEORADIUS", *arguments)
					end
				end
				
				# Query a sorted set representing a geospatial index to fetch members matching a given maximum distance from a member. O(N+log(M)) where N is the number of elements inside the bounding box of the circular area delimited by center and radius and M is the number of items inside the index.
				# See <https://redis.io/commands/georadiusbymember> for more details.
				# @parameter key [Key]
				# @parameter member [String]
				# @parameter radius [Double]
				# @parameter unit [Enum]
				# @parameter count [Integer] Limit the number of results to at most this many.
				# @parameter order [Symbol] `:ASC` Sort returned items from the nearest to the farthest, relative to the center. `:DESC` Sort returned items from the farthest to the nearest, relative to the center.
				# @parameter with_coordinates [Boolean] Also return the longitude,latitude coordinates of the matching items.
				# @parameter with_distance [Boolean] Also return the distance of the returned items from the specified center. The distance is returned in the same unit as the unit specified as the radius argument of the command.
				# @parameter with_hash [Boolean] Also return the raw geohash-encoded sorted set score of the item, in the form of a 52 bit unsigned integer. This is only useful for low level hacks or debugging and is otherwise of little interest for the general user.
				# @parameter store [Key]
				# @parameter store_distance [Key]
				def georadiusbymember(key, member, radius, unit = "m", with_coordinates: false, with_distance: false, with_hash: false, count: nil, order: nil, store: nil, store_distance: nil)
					arguments = [key, member, radius, unit]
					
					if with_coordinates
						arguments.append("WITHCOORD")
					end
					
					if with_distance
						arguments.append("WITHDIST")
					end
					
					if with_hash
						arguments.append("WITHHASH")
					end
					
					if count
						arguments.append("COUNT", count)
					end
					
					if order
						arguments.append(order)
					end
					
					if store
						arguments.append("STORE", store)
					end
					
					if store_distance
						arguments.append("STOREDIST", storedist)
					end
					
					readonly = true
					
					if store
						arguments.append("STORE", store)
						readonly = false
					end
					
					if store_distance
						arguments.append("STOREDIST", storedist)
						readonly = false
					end
					
					# https://redis.io/commands/georadius#read-only-variants
					if readonly
						call("GEORADIUSBYMEMBER_RO", *arguments)
					else
						call("GEORADIUSBYMEMBER", *arguments)
					end
				end
			end
		end
	end
end
