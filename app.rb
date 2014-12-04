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

use Rack::Session::Pool, :expire_after => 2592000

set :session_secret, '*&(^#234a)'

helpers do
	def current_user
		@current_user ||= User.get(session[:user_id], session[:username]) if session[:user_id] && session[:username]
	end
end


get '/' do

	if current_user
		erb :index
	else
		erb :login
	end

end

post '/' do

end

post '/registro' do

	@consult = User.first(:username => params[:username] )

	if !@consult && (params[:pass] == params[:pass1])
		name = params[:nombre]
		apellidos = params[:apellidos]
		pass =  params[:pass].to_i(32)		
		username = params[:username]

		@set_user = User.create(:username => username, :name => name, :last_name => apellidos, :password => pass)

		if @set_user
			session[:username] = @set_user.username
			session[:user_id] = @set_user.id
			redirect '/home'
		else
			@error_creacion = true
		end
	else
		@error_existe = true

		erb :login
	end

end

post '/login' do
	@consult = User.first(:username => params[:username], :password => params[:pass].to_i(32))

	if @consult
		session[:username] = @consult.username
		session[:user_id] = @consult.id
		redirect '/home'

	else
		@error_no_existe = true
		erb :login
	end
end

get '/home' do
	if current_user

		erb :index

	end
end

post '/home' do

end
get '/register' do
	erb :register
end

# URLs para los juegos
#Provisional, es necesario verificar que el usuario está logueado
get '/game' do
	if current_user
  		haml :game, :layout => :index
  	else
  		redirect '/'
  	end
end

#PintaMatematicas
get '/game/mathematics/draw' do
  #Para enlazar con el dibujo correspondiente
  #al nivel hay que extraer el curso del alumno
  #Provisionalmente se pone por defecto el mismo
  haml :mth_draw1, :layout => :index
end