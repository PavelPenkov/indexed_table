# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.authors       = ["Pavel Penkov"]
  gem.email         = ["ebonfortress@gmail.com"]
  gem.description   = %q{Simple implementation of table with indexes}
  gem.summary       = %q{Simple implementation of table with indexes}
  gem.homepage      = ""

  gem.add_development_dependency "rspec"
  gem.add_dependency "rbtree"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "indexed_table"
  gem.require_paths = ["lib"]
  gem.version       = "0.0.1"
end
