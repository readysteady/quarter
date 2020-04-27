Gem::Specification.new do |s|
  s.name = 'quarter'
  s.version = '1.0.0'
  s.license = 'LGPL-3.0'
  s.platform = Gem::Platform::RUBY
  s.authors = ['Tim Craft']
  s.email = ['mail@timcraft.com']
  s.homepage = 'https://github.com/readysteady/quarter'
  s.description = 'Ruby gem for working with standard calendar quarters'
  s.summary = 'See description'
  s.files = Dir.glob('lib/**/*.rb') + %w[LICENSE.txt README.md quarter.gemspec]
  s.require_path = 'lib'
  s.metadata = {
    'homepage' => 'https://github.com/readysteady/quarter',
    'source_code_uri' => 'https://github.com/readysteady/quarter',
    'bug_tracker_uri' => 'https://github.com/readysteady/quarter/issues'
  }
end