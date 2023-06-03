# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2019-2023, by Samuel Williams.

source 'https://rubygems.org'

# Specify your gem's dependencies in protocol-redis.gemspec
gemspec

group :test do
	gem "bake-test"
	gem "bake-test-external"
end
