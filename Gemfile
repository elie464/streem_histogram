source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.0'

gem 'rails', '~> 5.2.1'
gem 'sqlite3'
gem 'puma', '~> 3.11'
gem 'elasticsearch'
gem 'dotenv'
gem 'rack-cors'

group :test do
  gem 'rspec-rails'
  gem 'database_cleaner'
  gem 'shoulda-matchers'
  gem 'timecop'
  gem 'webmock'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'pry-byebug'
end
