# -*- encoding: utf-8 -*-
# stub: api-auth 2.2.1 ruby lib

Gem::Specification.new do |s|
  s.name = "api-auth".freeze
  s.version = "2.2.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Mauricio Gomes".freeze]
  s.date = "2018-03-12"
  s.description = "Full HMAC auth implementation for use in your gems and Rails apps.".freeze
  s.email = "mauricio@edge14.com".freeze
  s.homepage = "https://github.com/mgomes/api_auth".freeze
  s.required_ruby_version = Gem::Requirement.new(">= 2.1.0".freeze)
  s.rubygems_version = "2.7.7".freeze
  s.summary = "Simple HMAC authentication for your APIs".freeze

  s.installed_by_version = "2.7.7" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<actionpack>.freeze, ["< 6.0", "> 4.0"])
      s.add_development_dependency(%q<activeresource>.freeze, [">= 4.0"])
      s.add_development_dependency(%q<activesupport>.freeze, ["< 6.0", "> 4.0"])
      s.add_development_dependency(%q<amatch>.freeze, [">= 0"])
      s.add_development_dependency(%q<appraisal>.freeze, [">= 0"])
      s.add_development_dependency(%q<curb>.freeze, ["~> 0.8"])
      s.add_development_dependency(%q<faraday>.freeze, [">= 0.10"])
      s.add_development_dependency(%q<http>.freeze, [">= 0"])
      s.add_development_dependency(%q<httpi>.freeze, [">= 0"])
      s.add_development_dependency(%q<multipart-post>.freeze, ["~> 2.0"])
      s.add_development_dependency(%q<pry>.freeze, [">= 0"])
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
      s.add_development_dependency(%q<rest-client>.freeze, ["~> 2.0"])
      s.add_development_dependency(%q<rspec>.freeze, ["~> 3.4"])
    else
      s.add_dependency(%q<actionpack>.freeze, ["< 6.0", "> 4.0"])
      s.add_dependency(%q<activeresource>.freeze, [">= 4.0"])
      s.add_dependency(%q<activesupport>.freeze, ["< 6.0", "> 4.0"])
      s.add_dependency(%q<amatch>.freeze, [">= 0"])
      s.add_dependency(%q<appraisal>.freeze, [">= 0"])
      s.add_dependency(%q<curb>.freeze, ["~> 0.8"])
      s.add_dependency(%q<faraday>.freeze, [">= 0.10"])
      s.add_dependency(%q<http>.freeze, [">= 0"])
      s.add_dependency(%q<httpi>.freeze, [">= 0"])
      s.add_dependency(%q<multipart-post>.freeze, ["~> 2.0"])
      s.add_dependency(%q<pry>.freeze, [">= 0"])
      s.add_dependency(%q<rake>.freeze, [">= 0"])
      s.add_dependency(%q<rest-client>.freeze, ["~> 2.0"])
      s.add_dependency(%q<rspec>.freeze, ["~> 3.4"])
    end
  else
    s.add_dependency(%q<actionpack>.freeze, ["< 6.0", "> 4.0"])
    s.add_dependency(%q<activeresource>.freeze, [">= 4.0"])
    s.add_dependency(%q<activesupport>.freeze, ["< 6.0", "> 4.0"])
    s.add_dependency(%q<amatch>.freeze, [">= 0"])
    s.add_dependency(%q<appraisal>.freeze, [">= 0"])
    s.add_dependency(%q<curb>.freeze, ["~> 0.8"])
    s.add_dependency(%q<faraday>.freeze, [">= 0.10"])
    s.add_dependency(%q<http>.freeze, [">= 0"])
    s.add_dependency(%q<httpi>.freeze, [">= 0"])
    s.add_dependency(%q<multipart-post>.freeze, ["~> 2.0"])
    s.add_dependency(%q<pry>.freeze, [">= 0"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<rest-client>.freeze, ["~> 2.0"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3.4"])
  end
end
