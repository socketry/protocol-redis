# frozen_string_literal: true

require 'covered/rspec'

if RUBY_VERSION < "2.4.0"
	require_relative "extensions/chomp"
end

RSpec.configure do |config|
	config.disable_monkey_patching
	
	# Enable flags like --only-failures and --next-failure
	config.example_status_persistence_file_path = ".rspec_status"

	config.expect_with :rspec do |c|
		c.syntax = :expect
	end
end
