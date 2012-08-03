# -*- encoding: utf-8 -*-
require File.expand_path('../lib/ninja2k-scraper/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Randy Morgan"]
  gem.email         = ["digital.ipseity@gmail.com"]
  gem.description   = %q{A quick web resource scraper that lets you define xpath selectors, clues and hooks for custom parsing as well as export to xlsx.}
  gem.summary       = %q{}
  gem.homepage      = ""

  gem.files         = Dir.glob("{lib/**/*,example/**/*}") + %w(README.md LICENSE Rakefile)
  gem.test_files    = gem.files.grep("{test/**/*}")
  gem.name          = "ninja2k-scraper"
  gem.require_paths = ["lib"]
  gem.version       = Ninja2k::Scraper::VERSION

  gem.add_runtime_dependency 'nokogiri'
  gem.add_runtime_dependency 'axlsx'

end
