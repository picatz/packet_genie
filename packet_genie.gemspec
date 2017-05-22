# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'packet_genie/version'

Gem::Specification.new do |spec|
  spec.name          = "packet_genie"
  spec.version       = PacketGenie::VERSION
  spec.authors       = ["Kent 'picat' Gruber"]
  spec.email         = ["kgruber1@emich.edu"]

  spec.summary       = %q{Magically streaming live packet captures with a simple REST API}
  spec.homepage      = "https://github.com/picatz/packet_genie"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'pcaprub'
  spec.add_dependency 'sinatra'
  spec.add_dependency 'pry'
  spec.add_dependency 'colorize'
  spec.add_dependency 'trollop'

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
