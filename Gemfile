source "http://rubygems.org"
ruby "2.0.0"

gem 'sinatra'
gem 'omniauth'
gem 'omniauth-google-oauth2'
gem 'pry' 
gem 'erubis'
gem 'data_mapper'
gem 'sinatra-contrib'
gem 'haml'
gem 'chartkick'
gem 'dm-core'
gem 'time_difference'
gem 'dm-timestamps'
gem 'dm-types' 


group :production do
	gem "pg"
	gem "dm-postgres-adapter"
end

group :development do
	gem "sqlite3"
	gem "dm-sqlite-adapter"
end
group :test do
	gem 'selenium-webdriver'
	gem "sqlite3"
	gem "dm-sqlite-adapter"
    gem "rack-test"
    gem 'rspec'
    gem "rake"
    gem 'minitest'
	gem 'test-unit'
    gem 'coveralls'
end
