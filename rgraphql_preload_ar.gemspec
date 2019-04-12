Gem::Specification.new do |s|
  s.name = 'rgraphql_preload_ar'
  s.version = "1.0.2"
  s.date = Time.now.strftime("%Y-%m-%d")
  s.summary = %q{rails graphql preload ar in resolver}
  s.files = `git ls-files`.split($/)
  s.authors = ["tinyfeng.hou"]
  s.license = 'MIT'
  s.add_dependency "graphql", ">=1.8.11"
end
