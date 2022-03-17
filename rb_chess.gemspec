# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name = 'rb_chess'
  s.authors = ['Peter Abah']
  s.email = 'peterabah.ob@gmail.com'
  s.licenses = ['MIT']
  s.platform = Gem::Platform::RUBY
  s.summary = 'A chess library written in ruby'
  s.version = '0.0.0'
  s.homepage = 'https://github.com/peter-abah/rb_chess'
  s.files = Dir['lib/**/*.rb', 'README.md', 'LICENSE']
  s.executables = ['rb_chess']
end
