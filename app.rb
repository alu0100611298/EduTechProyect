#!/usr/bin/env ruby
require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'sinatra/reloader' if development?
require 'pry'
require 'omniauth-oauth2'
require 'omniauth-google-oauth2'
require 'data_mapper'
require 'erubis'
require 'pp'
require 'haml'
require 'chartkick'
require 'dm-core'
require 'dm-timestamps'
require 'dm-types'

configure :development do
    DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")
end

configure :production do
  DataMapper.setup(:default, ENV['DATABASE_URL'])
end

configure :test do
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/test.db")
end

DataMapper::Logger.new($stdout, :debug)
DataMapper::Model.raise_on_save_failure = true 

require_relative 'model'

DataMapper.finalize

#DataMapper.auto_migrate!
DataMapper.auto_upgrade!


get '/' do

	erb :index

end

get '/home' do

end

post '/home' do

end
get '/register' do
	erb :register
end

post '/' do
	print params
	#Crear un grado
	#if !Grade.first(:name => params["gname"])
	@table = Grade.first_or_create(:name => params["gname"], :class => params["gclass"], :promotion => params["gpromotion"])
	#end
	@grade = Grade.first(:name => params["gname"])
	#if !User.first(:name => params["uname"])
	#incluir usuarios en el grado
	@user = User.first(:username => params["uusername"])
	# No se puede repetir el nombre de usuario
	if(!@user)
		@user = User.first_or_create(:name => params["uname"], :last_name => params["ulast_name"], :username => params["uusername"], :profile_picture => params["uprofile_picture"], :created_at => Time.now, :grade => @grade)
	else
		print "Usuario creado"
	end
	#end
	redirect '/list'
end

get '/list' do
	@table = Grade.all
	@user = User.all
	erb :list
end