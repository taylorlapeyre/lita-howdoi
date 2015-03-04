Gem::Specification.new do |spec|
  spec.name          = "lita-howdoi"
  spec.version       = "0.0.2"
  spec.authors       = ["Taylor Lapeyre"]
  spec.email         = ["taylorlapeyre@gmail.com"]
  spec.description   = "Crawls Stack Overflow for the first answer it finds with a solution to some query."
  spec.summary       = "Crawls Stack Overflow for the first answer it finds with a solution to some query."
  spec.homepage      = "https://github.com/taylorlapeyre/lita-howdoi"
  spec.license       = "MIT"
  spec.metadata      = { "lita_plugin_type" => "handler" }

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "lita", ">= 4.2"
  spec.add_runtime_dependency "nokogiri"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rack-test"
  spec.add_development_dependency "rspec", ">= 3.0.0"
end
