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

get '/logout' do
	session.clear
	redirect '/'
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
get '/game' do
	if current_user
      game = Game.all(:user => current_user)
      @score = Hash.new
      @score['pintamatematicas'] = game.score('pintamatematicas')[0] || 0
      @score['memoria'] = game.score('memoria')[0] || 0
      @score['numbers'] = game.score('numbers')[0] || 0
      @score['colors'] = game.score('colors')[0] || 0
      @score['school'] = game.score('school')[0] || 0
      @score['calculator'] = game.score('calculator')[0] || 0
  		haml :game, :layout => :index
  	else
  		redirect '/'
  	end
end
get '/notes/delete' do
	if current_user
		user = User.first(:username => session[:username])
		Note.all(:user => user).destroy
		@notas = Note.all(:user => user)
  		redirect '/notes'
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

#Memory
get '/game/memory' do
  haml :memory, :layout => :index
end

get '/game/english/numbers' do
  haml :numbers, :layout => :index
end

get '/game/english/colors' do
  haml :colors, :layout => :index
end

get '/game/english/school' do
  haml :school, :layout => :index
end

get '/game/mathematics/calculator' do
  haml :calculator, :layout => :index
end

#Salvar el resultado de un juego en la BD
post '/game/save' do
  #Por defecto el nivel será 1
  user = User.first(:username => session[:username])
  Game.create(:user => user, :name => params['name'], :score => params['score'], :level => 1, :created_at => Time.now)
end


get '/notes' do
	if current_user
		user = User.first(:username => session[:username])
		@notas = Note.all(:user => user)
  		haml :notes, :layout => :index
  	else
  		redirect '/'
  	end
end

post '/notes' do
	if current_user
		#buscar el usuario
		user = User.first(:username => session[:username])
		#Guardar la nota
		nota = Note.first_or_create(:name => params[:asunto], :description => params[:texto], :created_at => Time.now, :finish_at => Time.now, :status => "false", :user =>user)
  		redirect '/notes'
  	else
  		redirect '/'
  	end
end

get '/message' do
	if current_user
		user = User.first(:username => session[:username])
		@recibidos = Message.all(:user => user, :tipo => "true")
		@enviados = Message.all(:user => user, :tipo => "false")
  		haml :message, :layout => :index
  	else
  		redirect '/'
  	end
end

post '/message' do
	if current_user
		#buscar el usuario
		usuario_recibe = User.first(:username => params[:username])
		redirect '/message' unless usuario_recibe
		usuario_envia = User.first(:username => session[:username])
		#Guarda el mensaje recibido
		Message.first_or_create(:from_user => session[:username], :description => params[:description], :message => params[:message], :created_at => Time.now, :status => "false", :tipo => "true", :user =>usuario_recibe)
		#Guarda el mensaje enviado
		Message.first_or_create(:from_user => params[:username], :description => params[:description], :message => params[:message], :created_at => Time.now, :status => "false", :tipo => "false", :user =>usuario_envia)
  		redirect '/message'
  	else
  		redirect '/'
  	end
end