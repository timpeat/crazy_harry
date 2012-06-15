# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "crazy_harry/version"

Gem::Specification.new do |s|
  s.name        = "crazy_harry"
  s.version     = CrazyHarry::VERSION
  s.authors     = ["TA Tyree"]
  s.email       = ["todd.tyree@lonelyplanet.co.uk"]
  s.homepage    = "https://github.com/lonelyplanet/crazy_harry"
  s.summary     = %q{High level HTML fragment sanitizer}
  s.description = %q{High level HTML fragment sanitizer}

  s.rubyforge_project = "crazy_harry"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'guard'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'simplecov'

  s.add_runtime_dependency 'loofah'
end
