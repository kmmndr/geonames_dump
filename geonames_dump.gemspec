# -*- encoding: utf-8 -*-
require File.expand_path('../lib/geonames_dump/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Alex Pooley", "Thomas Kienlen"]
  gem.email         = ["thomas.kienlen@lafourmi-immo.com"]
  gem.description   = %q{GeonamesDump import geographic data from geonames project into your application, avoiding to use external service like Google Maps.}
  gem.summary       = %q{Import data from Geonames}
  gem.homepage      = "https://github.com/kmmndr/geonames_dump"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "geonames_dump"
  gem.require_paths = ["lib"]
  gem.version       = GeonamesDump::VERSION
  gem.add_runtime_dependency 'ruby-progressbar'
  gem.add_runtime_dependency 'activerecord-reset-pk-sequence'
end
