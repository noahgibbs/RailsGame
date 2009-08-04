# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{railsgame}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Noah Gibbs"]
  s.description = %q{RailsGame makes it easy to link a Rails server to a two-way game server via Juggernaut server-push.}
  s.email = %q{noah_gibbs_remove_nospam@nospam.yahoo.com}
  #s.extra_rdoc_files = ["README.md", "LICENSE"]
  s.files = (['lib', 'rails', 'tasks', 'generators/railsgame'].map {|d|
      Dir[d + '/*.rb']
    }).sum
  s.test_files = Dir['test/*.rb']
  s.has_rdoc = true
  s.homepage = %q{http://railsgame.angelbob.com}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{railsgame}
  s.rubygems_version = %q{1.3.0}
  s.summary = %q{RailsGame makes it easy to link a Rails server to a two-way game server via Juggernaut server-push.}
