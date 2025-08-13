# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2023, by Samuel Williams.

require "protocol/redis/connection"
require "socket"

class Callable
	def call(*arguments)
	end
end

MethodsContext = Sus::Shared("a methods object") do |*modules|
	def class_including(*modules)
		subclass = Class.new(Callable)
		subclass.include(*modules)
		return subclass
	end
	
	let(:object) {class_including(*modules).new}
end
