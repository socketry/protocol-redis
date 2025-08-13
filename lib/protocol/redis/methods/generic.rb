# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2019-2023, by Samuel Williams.
# Copyright, 2021, by Troex Nevelin.

require "date"

module Protocol
	module Redis
		module Methods
			# Methods for interacting with Redis keys.
			module Generic
				# Delete a key. O(N) where N is the number of keys that will be removed. When a key to remove holds a value other than a string, the individual complexity for this key is O(M) where M is the number of elements in the list, set, sorted set or hash. Removing a single key that holds a string value is O(1).
				# See <https://redis.io/commands/del> for more details.
				# @parameter key [Key]
				def del(*keys)
					if keys.any?
						call("DEL", *keys)
					end
				end
				
				# Return a serialized version of the value stored at the specified key. O(1) to access the key and additional O(N*M) to serialized it, where N is the number of Redis objects composing the value and M their average size. For small string values the time complexity is thus O(1)+O(1*M) where M is small, so simply O(1).
				# See <https://redis.io/commands/dump> for more details.
				# @parameter key [Key]
				def dump(key)
					call("DUMP", key)
				end
				
				# Determine if a key exists. O(1).
				# See <https://redis.io/commands/exists> for more details.
				# @parameter key [Key]
				# @returns [Integer]
				def exists(key, *keys)
					call("EXISTS", key, *keys)
				end
				
				# Boolean oversion of `exists`
				# @parameter key [Key]
				# @returns [Boolean]
				def exists?(key, *keys)
					exists(key, *keys) > 0
				end
				
				# Set a key's time to live in seconds. O(1).
				# See <https://redis.io/commands/expire> for more details.
				# @parameter key [Key]
				# @parameter seconds [Integer]
				def expire(key, seconds)
					call("EXPIRE", key, seconds)
				end
				
				# Set the expiration for a key as a UNIX timestamp. O(1).
				# See <https://redis.io/commands/expireat> for more details.
				# @parameter key [Key]
				# @parameter timestamp [Posix time]
				def expireat(key, time)
					case time
					when DateTime, Time, Date
						timestamp = time.strftime("%s").to_i
					else
						timestamp = time
					end
					
					call("EXPIREAT", key, timestamp)
				end
				
				# Find all keys matching the given pattern. O(N) with N being the number of keys in the database, under the assumption that the key names in the database and the given pattern have limited length.
				# See <https://redis.io/commands/keys> for more details.
				# @parameter pattern [Pattern]
				def keys(pattern)
					call("KEYS", pattern)
				end
				
				# Atomically transfer a key from a Redis instance to another one. This command actually executes a DUMP+DEL in the source instance, and a RESTORE in the target instance. See the pages of these commands for time complexity. Also an O(N) data transfer between the two instances is performed.
				# See <https://redis.io/commands/migrate> for more details.
				# @parameter host [String]
				# @parameter port [String]
				# @parameter key [Enum]
				# @parameter destination-db [Integer]
				# @parameter timeout [Integer]
				# @parameter copy [Enum]
				# @parameter replace [Enum]
				def migrate(host, port, destination = 0, keys:, timeout: 0, copy: false, replace: false, auth: nil)
					raise ArgumentError, "Must provide keys" if keys.empty?
					
					arguments = [host, port]
					
					if keys.size == 1
						arguments.append(*keys)
					else
						arguments.append("")
					end
					
					arguments.append(destination, timeout)
					
					if copy
						arguments.append("COPY")
					end
					
					if replace
						arguments.append("REPLACE")
					end
					
					if auth
						arguments.append("AUTH", auth)
					end
					
					if keys.size > 1
						arguments.append("KEYS", *keys)
					end
					
					call("MIGRATE", *arguments)
				end
				
				# Move a key to another database. O(1).
				# See <https://redis.io/commands/move> for more details.
				# @parameter key [Key]
				# @parameter db [Integer]
				def move(key, db)
					call("MOVE", key, db)
				end
				
				# Inspect the internals of Redis objects. O(1) for all the currently implemented subcommands.
				# See <https://redis.io/commands/object> for more details.
				# @parameter subcommand [String]
				# @parameter arguments [String]
				def object(subcommand, *arguments)
					call("OBJECT", subcommand, *arguments)
				end
				
				# Remove the expiration from a key. O(1).
				# See <https://redis.io/commands/persist> for more details.
				# @parameter key [Key]
				def persist(key)
					call("PERSIST", key)
				end
				
				# Set a key's time to live in milliseconds. O(1).
				# See <https://redis.io/commands/pexpire> for more details.
				# @parameter key [Key]
				# @parameter milliseconds [Integer]
				def pexpire(key, milliseconds)
					call("PEXPIRE", milliseconds)
				end
				
				# Set the expiration for a key as a UNIX timestamp specified in milliseconds. O(1).
				# See <https://redis.io/commands/pexpireat> for more details.
				# @parameter key [Key]
				# @parameter milliseconds-timestamp [Posix time]
				def pexpireat(key, time)
					case time.class
					when DateTime, Time, Date 
						timestamp =  time.strftime("%Q").to_i
					else
						timestamp = time
					end
					
					call("PEXPIREAT", key, timestamp)
				end
				
				# Get the time to live for a key in milliseconds. O(1).
				# See <https://redis.io/commands/pttl> for more details.
				# @parameter key [Key]
				def pttl(key)
					call("PTTL", key)
				end
				
				# Return a random key from the keyspace. O(1).
				# See <https://redis.io/commands/randomkey> for more details.
				def randomkey
					call("RANDOMKEY")
				end
				
				# Rename a key. O(1).
				# See <https://redis.io/commands/rename> for more details.
				# @parameter key [Key]
				# @parameter newkey [Key]
				def rename(key, new_key)
					call("RENAME", key, new_key)
				end
				
				# Rename a key, only if the new key does not exist. O(1).
				# See <https://redis.io/commands/renamenx> for more details.
				# @parameter key [Key]
				# @parameter newkey [Key]
				def renamenx(key, new_key)
					call("RENAMENX", key, new_key)
				end
				
				# Create a key using the provided serialized value, previously obtained using DUMP. O(1) to create the new key and additional O(N*M) to reconstruct the serialized value, where N is the number of Redis objects composing the value and M their average size. For small string values the time complexity is thus O(1)+O(1*M) where M is small, so simply O(1). However for sorted set values the complexity is O(N*M*log(N)) because inserting values into sorted sets is O(log(N)).
				# See <https://redis.io/commands/restore> for more details.
				# @parameter key [Key]
				# @parameter ttl [Integer]
				# @parameter serialized-value [String]
				# @parameter replace [Enum]
				# @parameter absttl [Enum]
				def restore(key, serialized_value, ttl=0)
					call("RESTORE", key, ttl, serialized_value)
				end
				
				# Incrementally iterate the keys space. O(1) for every call. O(N) for a complete iteration, including enough command calls for the cursor to return back to 0. N is the number of elements inside the collection.
				# See <https://redis.io/commands/scan> for more details.
				# @parameter cursor [Integer]
				def scan(cursor, match: nil, count: nil, type: nil)
					arguments = [cursor]
					
					if match
						arguments.append("MATCH", match)
					end
					
					if count
						arguments.append("COUNT", count)
					end
					
					if type
						arguments.append("TYPE", type)
					end
					
					call("SCAN", *arguments)
				end
				
				# Sort the elements in a list, set or sorted set. O(N+M*log(M)) where N is the number of elements in the list or set to sort, and M the number of returned elements. When the elements are not sorted, complexity is currently O(N) as there is a copy step that will be avoided in next releases.
				# See <https://redis.io/commands/sort> for more details.
				# @parameter key [Key]
				# @parameter order [Enum]
				# @parameter sorting [Enum]
				def sort(key, by: nil, offset: nil, count: nil, get: nil, order: "ASC", alpha: false, store: nil)
					arguments = []
					
					if by
						arguments.append("BY", by)
					end
					
					if offset and count
						arguments.append("LIMIT", offset, count)
					end
					
					get&.each do |pattern|
						arguments.append("GET", pattern)
					end
					
					if order
						arguments.append(order)
					end
					
					if alpha
						arguments.append("ALPHA")
					end
					
					if store
						arguments.append("STORE", store)
					end
					
					call("SORT", *arguments)
				end
				
				# Alters the last access time of a key(s). Returns the number of existing keys specified. O(N) where N is the number of keys that will be touched.
				# See <https://redis.io/commands/touch> for more details.
				# @parameter key [Key]
				def touch(key, *keys)
					call("TOUCH", key, *keys)
				end
				
				# Get the time to live for a key. O(1).
				# See <https://redis.io/commands/ttl> for more details.
				# @parameter key [Key]
				def ttl(key)
					call("TTL", key)
				end
				
				# Determine the type stored at key. O(1).
				# See <https://redis.io/commands/type> for more details.
				# @parameter key [Key]
				def type(key)
					call("TYPE", key)
				end
				
				# Delete a key asynchronously in another thread. Otherwise it is just as DEL, but non blocking. O(1) for each key removed regardless of its size. Then the command does O(N) work in a different thread in order to reclaim memory, where N is the number of allocations the deleted objects where composed of.
				# See <https://redis.io/commands/unlink> for more details.
				# @parameter key [Key]
				def unlink(key)
					call("UNLINK", key)
				end
				
				# Wait for the synchronous replication of all the write commands sent in the context of the current connection. O(1).
				# See <https://redis.io/commands/wait> for more details.
				# @parameter numreplicas [Integer]
				# @parameter timeout [Integer]
				def wait(newreplicas, timeout = 0)
					call("WAIT", numreplicas, timeout)
				end
			end
		end
	end
end
