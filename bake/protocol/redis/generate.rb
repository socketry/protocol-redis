# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2019-2023, by Samuel Williams.

require 'async'

def commands
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

def methods
	require 'trenni/template'
	
	self.commands unless defined?(@commands)
	
	template = Trenni::Template.load_file(File.expand_path("methods.trenni", __dir__))
	
	@groups.each_pair do |spec_group, group|
		puts "Processing #{spec_group}..."
		
		path = File.expand_path("lib/protocol/redis/methods/#{group}.rb", context.root)
		
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

def documentation
	self.commands unless defined?(@commands)
	
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

private

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
