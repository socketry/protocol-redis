# frozen_string_literal: true

require_relative "lib/protocol/redis/version"

Gem::Specification.new do |spec|
	spec.name = "protocol-redis"
	spec.version = Protocol::Redis::VERSION
	
	spec.summary = "A transport agnostic RESP protocol client/server."
	spec.authors = ["Samuel Williams", "Dimitry Chopey", "Nick Burwell", "David Ortiz", "Nakul Warrier", "Troex Nevelin", "Daniel Evans", "Olle Jonsson", "Salim Semaoune"]
	spec.license = "MIT"
	
	spec.cert_chain  = ['release.cert']
	spec.signing_key = File.expand_path('~/.gem/release.pem')
	
	spec.homepage = "https://github.com/socketry/protocol-redis"
	
	spec.metadata = {
		"funding_uri" => "https://github.com/sponsors/ioquatix",
	}
	
	spec.files = Dir.glob(['{lib}/**/*', '*.md'], File::FNM_DOTMATCH, base: __dir__)
	
	spec.required_ruby_version = ">= 2.7"
end
