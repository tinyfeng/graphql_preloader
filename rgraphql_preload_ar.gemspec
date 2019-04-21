Gem::Specification.new do |s|
  s.name = 'graphql_preloader'
  s.version = "1.1.0"
  s.date = Time.now.strftime("%Y-%m-%d")
  s.summary = %q{rails graphql preload ar association in resolver}
  s.files = `git ls-files`.split($/)
  s.authors = ["tinyfeng.hou"]
  s.license = 'MIT'
  s.add_dependency "graphql", ">=1.8.11"
end
