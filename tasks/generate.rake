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
	
	def normalize(sentence)
		return nil if sentence.nil?
		
		sentence = sentence.strip
		
		if sentence.end_with?(".")
			return sentence
		else
			return "#{sentence}."
		end
	end
	
	def module_name(group)
		group.split('_').collect(&:capitalize).join
	end
	
	task :commands do
		require 'async/http/internet'
		require 'json'
		
		@commands = fetch_commands
		
		@commands.each do |command, command_spec|
			method_name = command.to_s.downcase.split(/[\s\-_]+/).join('_')
			command_spec[:method_name] = method_name
		end
		
		# There is a bit of a discrepancy between how the groups appear in the JSON and how they appear in the compiled documentation, this is a mapping from `commands.json` to documentation:
		@groups = {
			'generic' => 'generic',
			'string' => 'strings',
			'list' => 'lists',
			'set' => 'sets',
			'sorted_set' => 'sorted_sets',
			'hash' => 'hashes',
			'connection' => 'connection',
			'server' => 'server',
			'scripting' => 'scripting',
			'hyperloglog' => 'counting',
			'cluster' => 'cluster',
			'geo' => 'geospatial',
			'stream' => 'streams'
		}.freeze
	end
	
	task :methods => :commands do
		require 'trenni/template'
		
		template = Trenni::Template.load_file(File.expand_path("methods.trenni", __dir__))
		
		@groups.each_pair do |spec_group, group|
			puts "Processing #{spec_group}..."
			
			path = "lib/protocol/redis/methods/#{group}.rb"
			
			if File.exist?(path)
				puts "File already exists #{path}, skipping!"
				next
			end
			
			group_commands = @commands.select do |command, command_spec|
				command_spec[:group] == spec_group
			end
			
			output = template.to_string({
				module_name: module_name(group),
				group_commands: group_commands,
			})
			
			File.write(path, output)
			
			break
		end
	end
	
	task :documentation => :commands do
		@groups.each_pair do |spec_group, group|
			puts "Processing #{spec_group}..."
			
			path = "lib/protocol/redis/methods/#{group}.rb"
			
			unless File.exist?(path)
				puts "Could not find #{path}, skipping!"
				next
			end
			
			lines = File.readlines(path)
			
			group_commands = @commands.select do |command, command_spec|
				command_spec[:group] == spec_group
			end
			
			puts "\tFound #{group_commands.length} commands in this group."
			
			group_commands.each do |command, command_spec|
				puts "\tProcessing #{command}..."
				
				if offset = lines.find_index{|line| line.include?("def #{command_spec[:method_name]}")}
					puts "Found #{command} at line #{offset}."
					
					/(?<indentation>\s+)def/ =~ lines[offset]
					
					start = offset
					while true
						break unless lines[start-1] =~ /\s+#(.*?)\n/
						start -= 1
					end
					
					# Remove the comments:
					lines.slice!(start...offset)
					
					summary = [
						normalize(command_spec[:summary]),
						normalize(command_spec[:complexity])
					].compact
					
					comments = [
						summary.join(' '),
						"@see https://redis.io/commands/#{command.to_s.downcase}"
					]
					
					command_spec[:arguments]&.each do |argument|
						next if argument[:command] or argument[:type].nil? or argument[:type].is_a?(Array)
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
