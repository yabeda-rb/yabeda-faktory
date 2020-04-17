lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "yabeda/faktory/version"

Gem::Specification.new do |spec|
  spec.name    = "yabeda-faktory"
  spec.version = Yabeda::Faktory::VERSION
  spec.authors = ["Andrey Novikov"]
  spec.email   = ["envek@envek.name"]

  spec.summary = "Export performance metrics for Faktory worker for Ruby"
  spec.description = <<~DESC
    Yabeda plugin for easy collecting of most important Faktory Ruby worker metrics: number of executed jobs, job runtime, etc…
  DESC
  spec.homepage = "https://github.com/yabeda-rb/yabeda-faktory"
  spec.license  = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/yabeda-rb/yabeda-faktory"
  spec.metadata["changelog_uri"] = "https://github.com/yabeda-rb/yabeda-faktory/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.3.0"

  spec.add_dependency "yabeda", "~> 0.2"
  spec.add_dependency "faktory_worker_ruby", "~> 1.0"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "activejob", ">= 6.0"
end
