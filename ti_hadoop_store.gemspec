$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "ti_hadoop_store/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "ti_hadoop_store"
  s.version     = TiHadoopStore::VERSION
  s.authors     = ["Emmanuel Bastien"]
  s.email       = ["os@ebastien.name"]
  s.homepage    = "https://github.com/travel-intelligence"
  s.summary     = "TI Hadoop models adapter."
  s.description = "Hadoop adapter for the Travel Intelligence models."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["Rakefile", "README.md"]

  s.add_dependency "rails", "~> 3.2.17"
  s.add_dependency "impala"

  s.add_development_dependency "rspec-rails"
end
