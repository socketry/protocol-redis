# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"

Dir.glob('tasks/**/*.rake').each{|path| load(path)}

RSpec::Core::RakeTask.new

task :default => :spec
