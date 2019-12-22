# frozen_string_literal: true

# Copyright, 2018, by Samuel G. D. Williams. <http://www.codeotaku.com>
# Copyright, 2018, by Huba Nagy.
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

require 'date'

module Protocol
	module Redis
		module Methods
			module Generic
				def del(*keys)
					if keys.any?
						return call('DEL', *keys)
					end
				end
				
				def dump(key)
					return call('DUMP', key)
				end
				
				def exists(key, *keys)
					return call('EXISTS', key, *keys)
				end
				
				def expire(key, seconds)
					return call('EXPIRE', key, seconds)
				end
				
				def expireat(key, time)
					case time
					when DateTime, Time, Date
						timestamp = time.strftime('%s').to_i
					else
						timestamp = time
					end
					
					return call('EXPIREAT', key, timestamp)
				end
				
				def keys(pattern)
					return call('KEYS', pattern)
				end
				
				# MIGRATE host port key|"" destination-db timeout [COPY] [REPLACE] [AUTH password] [KEYS key [key ...]]
				def migrate(host, port, destination = 0, keys:, timeout: 0, copy: false, replace: false, auth: nil, )
					raise ArgumentError, "Must provide keys" if keys.empty?
					
					arguments = [host, port]
					
					if keys.size == 1
						arguments.append(*keys)
					else
						arguments.append("")
					end
					
					arguments.append(destination, timeout)
					
					if keys.size > 1
						arguments.append("KEYS", *keys)
					end
					
					return call("MIGRATE", *arguments)
				end
				
				def move(key, db)
					return call('MOVE', key, db)
				end
				
				def object(subcommand, *arguments)
					call('OBJECT', subcommand, *arguments)
				end
				
				def persist(key)
					return call('PERSIST', key)
				end
				
				def pexpire(key, milliseconds)
					return call('PEXPIRE', milliseconds)
				end
				
				def pexpireat(key, time)
					case time.class
					when DateTime, Time, Date 
						timestamp =  time.strftime('%Q').to_i
					else
						timestamp = time
					end
					
					return call('PEXPIREAT', key, timestamp)
				end
				
				def pttl(key)
					return call('PTTL', key)
				end
				
				def randomkey
					return call('RANDOMKEY')
				end
				
				def rename(key, new_key)
					return call('RENAME', key, new_key)
				end
				
				def renamenx(key, new_key)
					return call('RENAMENX', key, new_key)
				end
				
				def restore(key, serialized_value, ttl=0)
					return call('RESTORE', key, ttl, serialized_value)
				end
				
				# SCAN cursor [MATCH pattern] [COUNT count] [TYPE type]
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
					
					return call("SCAN", *arguments)
				end
				
				# https://redis.io/commands/sort
				def sort(key, by: nil, offset: nil, count: nil, get: nil, order: 'ASC', alpha: false, store: nil)
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
					
					return call('SORT', *arguments)
				end
				
				def touch(key, *keys)
					return call('TOUCH', key, *keys)
				end
				
				def ttl(key)
					return call('TTL', key)
				end
				
				def type(key)
					return call('TYPE', key)
				end
				
				def unlink(key)
					return call('UNLINK', key)
				end
					
				def wait(newreplicas, timeout = 0)
					return call("WAIT", numreplicas, timeout)
				end
			end
		end
	end
end
