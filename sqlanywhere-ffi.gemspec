Gem::Specification.new do |s|
  s.name = "sqlanywhere-ffi"
  s.summary = "A low-lever driver that allows Ruby code to interface with SQL Anywhere databases"
  s.description = <<-DESCRIPTION
    This library wraps the functionality provided by the SQL Anywhere DBCAPI library.
    This driver is intended to be a base-level library to be used by interface libraries such as Ruby-DBI and ActiveRecord.
    This driver can be used with SQL Anywhere 10 and later versions.
    DESCRIPTION
  s.version = "1.0.1"
  s.author = "Chris Couzens"
  s.email = "ccouzens@gmail.com"
  s.files = Dir['**/**']
  s.executables = []
  s.test_files = Dir["test/sqlanywhere_test.rb"]
  s.has_rdoc = false
  s.add_dependency 'ffi', '>= 1.3.1'
  s.homepage = 'https://github.com/in4systems/sqlanywhere'
  s.requirements = <<-REQUIREMENTS
    DBCAPI should be installed.
    http://www.sybase.co.uk/detail?id=1087327
    It should also be in your library path.
    On Linux, this can be done by running: source /opt/sqlanywhere12/bin64/sa_config.sh
  REQUIREMENTS
end

