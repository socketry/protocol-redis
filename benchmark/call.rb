#!/usr/bin/env ruby
# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2020-2025, by Samuel Williams.

require "benchmark/ips"

GC.disable

def call(*arguments)
	arguments.size
end

Benchmark.ips do |benchmark|
	benchmark.time = 5
	benchmark.warmup = 1
	
	benchmark.report("*arguments") do |count|
		while count > 0
			arguments = ["foo", "bar", "baz"]
			call(*arguments)
			
			count -= 1
		end
	end
	
	benchmark.report("argument, *arguments") do |count|
		while count > 0
			arguments = ["bar", "baz"]
			call("foo", *arguments)
			
			count -= 1
		end
	end
	
	benchmark.compare!
end
