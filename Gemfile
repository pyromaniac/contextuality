def darwin_only(require_as)
  RUBY_PLATFORM.include?('darwin') && require_as
end

def linux_only(require_as)
  RUBY_PLATFORM.include?('linux') && require_as
end

source 'https://rubygems.org'

# Specify your gem's dependencies in cms_engine.gemspec
gemspec

gem 'rspec'
gem 'guard'
gem 'guard-rspec'

group :test do
  gem 'rb-fsevent', require: darwin_only('rb-inotify')
  gem 'rb-inotify', require: linux_only('rb-inotify')
  gem 'libnotify'
end