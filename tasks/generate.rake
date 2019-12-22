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

require 'async'

namespace :generate do
	def fetch_commands
		Async do
			internet = Async::HTTP::Internet.new
			
			response = internet.get("https://raw.githubusercontent.com/antirez/redis-doc/master/commands.json")
			
			JSON.parse(response.read, symbolize_names: true)
		ensure
			internet&.close
		end.wait
	end

	task :commands do
		require 'async/http/internet'
		require 'json'
		
		@commands = fetch_commands
		
		# There is a bit of a discrepancy between how the groups appear in the JSON and how they appear in the compiled documentation, this is a mapping from `commands.json` to documentation:
		@groups = {
			'string' => 'strings',
			'list' => 'lists',
			'set' => 'sets',
			'sorted_set' => 'sorted_sets',
			'hash' => 'hashes',
			'connection' => 'connection',
			'server' => 'server',
			'scripting' => 'scripting',
			'hyperloglog' => 'hyper_log_log',
			'cluster' => 'cluster',
			'geo' => 'geo',
			'stream' => 'streams'
		}.freeze
	end

	task :documentation => :commands do
		@groups.each_pair do |spec_group, group|
			puts "Processing #{spec_group}..."
			
			# CamelCase for the module name
			module_name = group.split('_').collect(&:capitalize).join
			
			path = "lib/protocol/redis/methods/#{group}.rb"
			lines = File.readlines(path)
			
			group_commands = @commands.select do |command, command_spec|
				command_spec[:group] == spec_group
			end
			
			puts "\tFound #{group_commands.length} commands in this group."
			
			group_commands.each do |command, command_spec|
				puts "\tProcessing #{command}..."
				method_name = command.to_s.downcase.split(/\s+\-/).join('_')
				
				pp command_spec
				
				if offset = lines.find_index{|line| line.include?("def #{method_name}")}
					puts "Found #{command} at line #{offset}."
					
					/(?<indentation>\s+)def/ =~ lines[offset]
					
					start = offset
					while true
						break unless lines[start-1] =~ /\s+#(.*?)\n/
						start -= 1
					end
					
					# Remove the comments:
					lines.slice!(start...offset)
					comments = [
						"#{command_spec[:summary]}. #{command_spec[:complexity]}",
						"@see https://redis.io/commands/#{command.to_s.downcase}"
					]
					
					command_spec[:arguments].each do |argument|
						next if argument[:command] or argument[:type].is_a?(Array)
						comments << "@param #{argument[:name]} [#{argument[:type].capitalize}]"
					end
					
					lines.insert(start, comments.map{|comment| "#{indentation}\# #{comment}\n"})
				else
					puts "Could not find #{command} definition!"
				end
			end
			
			File.write(path, lines.join)
		end
	end
end
