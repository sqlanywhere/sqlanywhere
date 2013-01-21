Gem::Specification.new do |s|
  s.name = "sqlanywhere"
  s.summary = "A low-lever driver that allows Ruby code to interface with SQL Anywhere databases"
  s.description = File.read(File.join(File.dirname(__FILE__), 'README.md'))
  s.version = "2.0.0"
  s.author = "Chris Couzens"
  s.email = "ccouzens@gmail.com"
  s.files = Dir['**/**']
  s.executables = []
  s.test_files = Dir["test/tst*.rb"]
  s.has_rdoc = false
  s.add_dependency 'ffi', '>= 1.3.1'
end

