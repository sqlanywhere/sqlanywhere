#====================================================
#
#    Copyright 2012 iAnywhere Solutions, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#                                                                               
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#
# See the License for the specific language governing permissions and
# limitations under the License.
#
# While not a requirement of the license, if you do modify this file, we
# would appreciate hearing about it.   Please email sqlany_interfaces@sybase.com
#
#
#====================================================

require 'fileutils'
require 'rbconfig'
require 'rake/clean'
require 'rdoc/task'
require 'rubygems'
require 'rubygems/builder'

# By default, windows will try to use nmake instead of make. If you are on windows but using
# a different compiler that uses standard make, set this to false.
USE_NMAKE_ON_WIN = true

# By default on windows, ruby expects to be compiled by Visual Studio C++ 6.0. If you are using 
# a newer version of Visual Studio, you will need to apply a manifest to the dll. To apply the
# manifest set this to true.
APPLY_MANIFEST = false

PACKAGE_NAME = "sqlanywhere"
ARCH=RbConfig::CONFIG['arch']

Dir.mkdir('lib') unless File.directory?('lib')
pkg_version = ""

library_file = ARCH =~ /darwin/ ? "sqlanywhere.bundle" : "sqlanywhere.so"

# The package version of determined by parsing the c source file. This ensures the version is
# only ever specified ins a single place.
File.open(File.join("ext", "sqlanywhere.c") ) do |f|
   f.grep( /const char\* VERSION/ ) do |line|
      pkg_version = /\s*const char\* VERSION\s*=\s*["|']([^"']*)["|'];\s*/.match(line)[1]
   end
end

# If we can't determine the version, throw up your hands and exit
raise RuntimeError, "Could not determine current package version!" if pkg_version.empty?

MAKE = (ARCH =~ /win32/ and USE_NMAKE_ON_WIN) ? 'nmake' : 'make'

spec = Gem::Specification.new do |spec|
  spec.authors = ["Eric Farrar"]
  spec.email = 'eric.farrar@ianywhere.com'
  spec.name = 'sqlanywhere'
  spec.summary = 'SQL Anywhere library for Ruby'
  spec.description = <<-EOF
    SQL Anywhere  Driver for Ruby
  EOF
  spec.version = pkg_version
  #spec.autorequire = 'sqlanywhere'
  spec.has_rdoc = true
  spec.rubyforge_project = 'sqlanywhere'
  spec.homepage = 'http://sqlanywhere.rubyforge.org'
  spec.required_ruby_version = '>= 1.8.6'
  spec.require_paths = ['lib']
  spec.test_file  = 'test/sqlanywhere_test.rb'
  spec.rdoc_options << '--title' << 'SQL Anywhere Ruby Driver' <<
                       '--main' << 'README' <<
                       '--line-numbers'
  spec.extra_rdoc_files = ['README', 'CHANGELOG', 'LICENSE', 'ext/sqlanywhere.c']
end

# The default task is to build the library (.dll or .so)
desc "Build the library"
task :default => [File.join("lib", library_file)]

# Builds the binary gem for this platform
desc "Build the gem"
task :gem => ["sqlanywhere-#{pkg_version}-#{spec.platform}.gem"]

file "sqlanywhere-#{pkg_version}-#{spec.platform}.gem" => ["Rakefile", 
                                             "test/test.sql", 
                                             "test/sqlanywhere_test.rb", 
                                             "README", 
                                             "CHANGELOG", 
                                             "LICENSE", 
                                             File.join("lib", library_file)] do
   # Get the updated list of files to include in the gem
   spec.files = Dir['ext/**/*'] + Dir['lib/**/*'] + Dir['test/**/*'] + Dir['CHANGELOG'] + Dir['LICENSE'] + Dir['README'] + Dir['Rakefile']
   # Set the gem to be platform specific since it includes compiled binaries   
   spec.platform = Gem::Platform::CURRENT
   #spec.extensions = ''
   Gem::Builder.new(spec).build
end

# Builds the source gem for any platform
desc "Build the source gem"
task :source_gem => ["sqlanywhere-#{pkg_version}.gem"]

file "sqlanywhere-#{pkg_version}.gem" => ["Rakefile", 
                                          "test/test.sql", 
                                          "test/sqlanywhere_test.rb", 
                                          "README", 
                                          "CHANGELOG", 
                                          "LICENSE"] do
   # Get the updated list of files to include in the gem
   spec.files = Dir['ext/**/*'] + Dir['lib/**/*'] + Dir['test/**/*'] + Dir['CHANGELOG'] + Dir['LICENSE'] + Dir['README'] + Dir['Rakefile']
   # Since this contains no compilked binaries, set it to be platform RUBY
   spec.extensions = 'ext/extconf.rb'
   Gem::Builder.new(spec).build
end

file File.join("lib", library_file) => [File.join("ext", library_file)] do
   FileUtils.copy(File.join("ext", library_file), "lib")
end

file File.join("ext", library_file) => ["ext/sqlanywhere.c"] do
   sh "cd ext && ruby extconf.rb"
   sh "cd ext && #{MAKE}"
   sh "cd ext && mt -outputresource:sqlanywhere.so;2 -manifest sqlanywhere.so.manifest" if APPLY_MANIFEST
end

desc "Install the gem"
task :install => [:gem] do
     sh "gem install sqlanywhere-#{pkg_version}-#{spec.platform}.gem"
end

# This builds the distributables. On windows it builds a platform specific gem, a source gem, and a souce zip archive.
# On other platforms this builds a platform specific gem, a source gem, and a source tar.gz archive.
desc "Build distributables (src zip, src tar.gz, gem)"
task :dist do |t|
   puts "Cleaning Build Environment..."
   Rake.application['clobber'].invoke   

   files = Dir.glob('*')

   puts "Creating #{File.join('build', PACKAGE_NAME)}-#{pkg_version} directory..." 
   FileUtils.mkdir_p "#{File.join('build', PACKAGE_NAME)}-#{pkg_version}"

   puts "Copying files to #{File.join('build', PACKAGE_NAME)}-#{pkg_version}..." 
   FileUtils.cp_r files, "#{File.join('build', PACKAGE_NAME)}-#{pkg_version}"

   if( ARCH =~ /win32/ ) then
      system "attrib -R #{File.join('build', PACKAGE_NAME)}-#{pkg_version} /S"
   else
      system "find #{File.join('build', PACKAGE_NAME)}-#{pkg_version} -type d -exec chmod 755 {} \\;"
      system "find #{File.join('build', PACKAGE_NAME)}-#{pkg_version} -type f -exec chmod 644 {} \\;"
   end

   if( ARCH =~ /win32/ ) then   
      puts "Creating #{File.join('build', PACKAGE_NAME)}-#{pkg_version}.zip..." 
      system "cd build && zip -q -r #{PACKAGE_NAME}-#{pkg_version}.zip #{PACKAGE_NAME}-#{pkg_version}"   
   else
      puts "Creating #{File.join('build', PACKAGE_NAME)}-#{pkg_version}.tar..." 
      system "tar cf #{File.join('build', PACKAGE_NAME)}-#{pkg_version}.tar -C build #{PACKAGE_NAME}-#{pkg_version}"
      
      puts "GZipping to create #{File.join('build', PACKAGE_NAME, PACKAGE_NAME)}-#{pkg_version}.tar.gz..." 
      system "gzip #{File.join('build', PACKAGE_NAME)}-#{pkg_version}.tar"
   end

   puts "Building GEM source distributable..." 
   Rake.application['source_gem'].invoke   

   puts "Copying source GEM to #{File.join('build', PACKAGE_NAME)}-#{pkg_version}.gem..." 
   FileUtils.cp "#{PACKAGE_NAME}-#{pkg_version}.gem", "build"

   puts "Building GEM binary distributable..." 
   Rake.application['gem'].invoke   

   puts "Copying binary GEM to #{File.join('build', PACKAGE_NAME)}-#{pkg_version}-#{spec.platform}.gem..." 
   FileUtils.cp "#{PACKAGE_NAME}-#{pkg_version}-#{spec.platform}.gem", "build"
end

RDoc::Task.new do |rd|
   rd.title = "SQL Anywhere Ruby Driver"
   rd.main = "README"
   rd.rdoc_files.include('README', 'CHANGELOG', 'LICENSE', 'ext/sqlanywhere.c')
end

desc "Publish the RDOCs on RubyForge"
task :publish_rdoc => ["html/index.html"] do
  system "pscp -r html/* efarrar@rubyforge.org:/var/www/gforge-projects/sqlanywhere/sqlanywhere"
end

CLOBBER.include("sqlanywhere-#{pkg_version}-#{spec.platform}.gem", "sqlanywhere-#{pkg_version}.gem", "lib/*", "ext/*.obj", "ext/*.def", "ext/*.so", "ext/*.bundle", "ext/*.log", "ext/*.exp", "ext/*.lib", "ext/*.pdb", "ext/Makefile", "ext/*.so.manifest", "ext/*.o", "build/**/*", "build")
