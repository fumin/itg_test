Gem::Specification.new do |s|
  s.name        = 'itg_test'
  s.version     = '0.0.0'
  s.date        = '2012-08-29'
  s.summary     = "rails integration test"
  s.description = "for rails apps that are too complicated to be tested with builtin integration test"
  s.authors     = ["awawfumin"]
  s.email       = 'fumin@cardinalblue.com'
  s.files       = [
    ".gitignore",
    "lib/itg_test.rb",
    "lib/itg_test/http_client.rb",
    "lib/itg_test/railtie.rb",
    "lib/itg_test/test_case.rb",
    "lib/tasks/test_itg.rake",
    "itg_test.gemspec",
    "README.md"
  ]
  s.homepage    = 'https://github.com/fumin/itg_test'
  s.add_runtime_dependency "nokogiri", [">= 0"]
end
