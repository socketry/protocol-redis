
require_relative "lib/protocol/redis/version"

Gem::Specification.new do |spec|
	spec.name = "protocol-redis"
	spec.version = Protocol::Redis::VERSION
	
	spec.summary = "A transport agnostic RESP protocol client/server."
	spec.authors = ["Samuel Williams", "Huba Nagy"]
	spec.license = "MIT"
	
	spec.homepage = "https://github.com/socketry/protocol-redis"
	
	spec.metadata = {
		"funding_uri" => "https://github.com/sponsors/ioquatix",
	}
	
	spec.files = Dir.glob('{lib}/**/*', File::FNM_DOTMATCH, base: __dir__)

	spec.required_ruby_version = ">= 2.5"
	
	spec.add_development_dependency "async-http"
	spec.add_development_dependency "bake"
	spec.add_development_dependency "bake-bundler"
	spec.add_development_dependency "bake-modernize"
	spec.add_development_dependency "benchmark-ips"
	spec.add_development_dependency "bundler"
	spec.add_development_dependency "covered"
	spec.add_development_dependency "rspec", "~> 3.6"
	spec.add_development_dependency "trenni"
end
