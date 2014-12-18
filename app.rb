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
require 'time_difference'

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
	@titulo = ""

	if current_user
		redirect '/home'
	else
		if session['error']
			@error = session['error']
		    session.delete('error')
		end
		haml :login, :layout => false
	end

end

post '/' do
	@titulo = ""
end


post '/registro' do

	@consult = User.first(:username => params[:username] )
	if !params[:pass] or !params[:pass1] or !params[:nombre] or !params[:apellidos] or !params[:username] or !params[:sexo]
		session['error'] = 'Faltan datos en el registro'
		redirect '/'
	elsif params[:pass] != params[:pass1]
		session['error'] = 'Las constraseñas son distintas'
		redirect '/'
	elsif !@consult && (params[:pass] == params[:pass1])
		name = params[:nombre]
		apellidos = params[:apellidos]
		pass =  params[:pass].to_i(32)		
		username = params[:username]
		sexo = params[:sexo]
		@set_user = User.create(:username => username, :name => name, :last_name => apellidos, :password => pass, :sexo => sexo)

		if @set_user
			session[:username] = @set_user.username
			session[:user_id] = @set_user.id
			redirect '/home'
		else
			@error_creacion = true
			session['error'] = 'No se ha podido completar el registro'
			redirect '/'
		end
	else
		session['error'] = 'El usuario ya existe'
		@error_existe = true
		redirect '/'
	end

end

post '/login' do

	consult = User.first(:username => params[:username])
	@consult = User.first(:username => params[:username], :password => params[:pass].to_i(32))
	if !consult
		session['error'] = 'No se encuentra el usuario'
		@error_no_existe = true
		redirect '/'
	elsif !@consult
		session['error'] = 'La constraseña no es correcta'
		@error_no_existe = true
		redirect '/'
	else
		session[:username] = @consult.username
		session[:user_id] = @consult.id
		redirect '/home'
	end
end

get '/logout' do
  session.clear
  session = nil
	redirect '/'
end

get '/home' do
	if current_user
	@titulo = ""
    alerts(current_user.id.to_s)
    @alerts = Alert.all(:to_user => current_user.id.to_s, :status => false)#Para mostrar nuevos mensajes en cuanto se entre.
    user = User.first(:username => session[:username])
    @nuevos = Message.all(:user => user, :tipo => "true", :order => [ :created_at.desc ], :status => "false")
    game = Game.all(:user_id => current_user.id)
    
    @better =  game.better_score(current_user.id.to_s) || nil
    if @better != nil
      if @better.name == 'colors'
        @game = ['Colors, English','/game/english/colors','/img/games/colors.png']
      elsif @better.name == 'memoria'
        @game = ['Memoria','/game/memory','/img/games/memory.png']
      elsif @better.name == 'numbers'
        @game = ['Numbers','/game/english/numbers','/img/games/numbers.png']
      elsif @better.name == 'pintamatematicas'
        @game = ['PintaMates','/game/mathematics/draw','/img/games/mathematics_draw_partial.png']
      elsif @better.name == 'school'
        @game = ['School, English','/game/english/school','/img/games/school.png']
      elsif @better.name == 'calculator'
        @game = ['Calculadoraa!!','/game/mathematics/calculator','/img/games/calculator.png']
      elsif @better == 0
        @game = [1,2,3]
      end
    end
    @notas = Note.all(:user => user, :order => [ :created_at.desc ], :limit => 3)
    haml :home, :layout => :index
	else
    redirect '/'
  end
end

post '/home' do
	if current_user
		@titulo = ""

	else
		redirect '/'
	end
end

# URLs para los juegos
get '/game' do
	if current_user
		@titulo = "Sección de Juegos"
		@alerts = Alert.all(:to_user => current_user.id.to_s, :status => false)
		game = Game.all(:user_id => current_user.id)

    score = Hash.new
    score['pintamatematicas'] = game.score('pintamatematicas',current_user.id.to_s)[0] || 0
    score['memoria'] = game.score('memoria',current_user.id.to_s)[0] || 0
    score['numbers'] = game.score('numbers',current_user.id.to_s)[0] || 0
    score['colors'] = game.score('colors',current_user.id.to_s)[0] || 0
    score['school'] = game.score('school',current_user.id.to_s)[0] || 0
    score['calculator'] = game.score('calculator',current_user.id.to_s)[0] || 0

    @games = [
      ['Colors, English',score['colors'],'¿Te sabes los colores en inglés?','/game/english/colors','/img/games/colors.png'],
      ['Memoria',score['memoria'],'Memoriza las parejas para completar el juego','/game/memory','/img/games/memory.png'],
      ['Numbers',score['numbers'],'¿Te sabes los números en inglés?','/game/english/numbers','/img/games/numbers.png'],
      ['PintaMates',score['pintamatematicas'],'Completa los colores usando las matemáticas','/game/mathematics/draw','/img/games/mathematics_draw_partial.png'],
      ['School, English',score['school'],'¿Cómo se dice lo que usas en clase en inglés?','/game/english/school','/img/games/school.png'],
      ['Calculadoraa!!',score['calculator'],'¿Eres una calculadora humana?','/game/mathematics/calculator','/img/games/calculator.png']
    ]
  		haml :game, :layout => :index
  	else
  		redirect '/'
  	end
end
get '/notes/delete' do
	if current_user
		@titulo = "Sección de Notas"
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
  if current_user
  	@titulo = "Pinta Matemáticas"
    @alerts = Alert.all(:to_user => current_user.id.to_s, :status => false)
  	haml :mth_draw1, :layout => :index
  else
  	redirect '/'
  end
end

#Memory
get '/game/memory' do
	if current_user
		@titulo = "Sección de Juegos"
    	@alerts = Alert.all(:to_user => current_user.id.to_s, :status => false)
 		haml :memory_level, :layout => :index
 	else
 		redirect '/'
 	end
end

get '/game/memory/:level' do
  if current_user
  	@titulo = "Sección de Juegos"
    @alerts = Alert.all(:to_user => current_user.id.to_s, :status => false)
    @level = params['level']
    haml :memory, :layout => :index
  else
    redirect '/'
  end
end

get '/game/english/numbers' do
	if current_user
		@titulo = "Numbers"
    	@alerts = Alert.all(:to_user => current_user.id.to_s, :status => false)
  		haml :numbers, :layout => :index
  	else
  		redirect '/'
  	end
end

get '/game/english/colors' do
	if current_user
		@titulo = "Colors"
    	@alerts = Alert.all(:to_user => current_user.id.to_s, :status => false)
  		haml :colors, :layout => :index
  	else
  		redirect '/'
  	end
end

get '/game/english/school' do
	if current_user
		@titulo = "School Things"
    	@alerts = Alert.all(:to_user => current_user.id.to_s, :status => false)
  		haml :school, :layout => :index
  	else
  		redirect '/'
  	end
end

get '/game/mathematics/calculator' do
	if current_user
		@titulo = "Caculadoraaaaa!!"
    	@alerts = Alert.all(:to_user => current_user.id.to_s, :status => false)
 		haml :calculator, :layout => :index
 	else
 		redirect '/'
 	end
end

#Salvar el resultado de un juego en la BD
post '/game/save' do
	if current_user
		@titulo = "Sección de Juegos"
	  #Por defecto el nivel será 1
	  	user = User.first(:username => session[:username])
    	level = params['level'] || 1
	  	Game.create(:user => user, :name => params['name'], :score => params['score'], :level => level, :created_at => Time.now)
	else
		redirect '/'
	end
end


get '/notes' do
	if current_user
		@titulo = "Sección de Notas"
    	@alerts = Alert.all(:to_user => current_user.id.to_s, :status => false)
		user = User.first(:username => session[:username])
		@notas = Note.all(:user => user, :order => [ :created_at.desc ])
		if session['error'] && session['error'] == 'error_nota'
		    @error = 'No se puede guardar la nota'
		    session.delete('error')
		end
  		haml :notes, :layout => :index
  	else
  		redirect '/'
  	end
end

get '/notes/delete/:identifier' do
	if current_user
		#buscar la nota
		@titulo = "Sección de Juegos"
		message = Note.first(:id => params[:identifier])
		message.destroy
		redirect '/notes'
  	else
  		redirect '/'
  	end
end

post '/notes' do
	if current_user
		@titulo = "Sección de Juegos"
		#buscar el usuario
		user = User.first(:username => session[:username])
		#Guardar la nota
		nota = Note.first_or_create(:name => params[:asunto], :description => params[:texto], :created_at => Time.now, :finish_at => Time.now, :status => "false", :user =>user)
  		if(!user or !nota)
  			session['error'] = 'error_nota'
  		end
  		redirect '/notes'
  	else
  		redirect '/'
  	end
end

get '/message' do
	if current_user
		@titulo = "Mensajes"
    	@alerts = Alert.all(:to_user => current_user.id.to_s, :status => false)
		user = User.first(:username => session[:username])
		@recibidos = Message.all(:user => user, :tipo => "true", :order => [ :created_at.desc ])
		@enviados = Message.all(:user => user, :tipo => "false", :order => [ :created_at.desc ])
		@nuevos = Message.all(:user => user, :tipo => "true", :order => [ :created_at.desc ], :status => "false")
		if session['error'] && session['error'] == 'error_usuario'
		    @error = 'No se puede enviar el mensaje el usuario no existe'
		    session.delete('error')
		end
  		haml :message, :layout => :index
  	else
  		redirect '/'
  	end
end
get '/message/open/:identifier' do
	if current_user
		@titulo = "Mensajes"
		#buscar el mensaje
		message = Message.first(:id => params[:identifier])
		message.status =  "true"
		message.save
		return message.message
  	else
  		redirect '/'
  	end
end

get '/message/opened' do
  if current_user
  	@titulo = "Mensajes"
    #buscar el mensaje
    user = User.first(:username => session[:username])
    nuevos = Message.all(:user => user, :tipo => "true", :order => [ :created_at.desc ], :status => "false")
    puts nuevos.size
    return nuevos.size.to_s
  else
      redirect '/'
  end
end

get '/message/delete/:identifier' do
	if current_user
		@titulo = "Mensajes"
		#buscar la nota
		message = Message.first(:id => params[:identifier])
		message.destroy
		return nil
  	else
  		redirect '/'
  	end
end

post '/message' do
	if current_user
		@titulo = "Mensajes"
		#buscar el usuario
		usuario_recibe = User.first(:username => params[:username])
		if(!usuario_recibe)
  			session['error'] = 'error_usuario'
  		end
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

post "/clear/alert/:id" do
	
  alert = Alert.first(:id => params['id'])
  alert.update(:status => true)
  redirect '/game'
end

def alerts(id)
  alerts_games = [
    ['memoria',500,'No crees que necesitas mejorar en memoria'],
    ['pintamatematicas',250,'¿Una partida a pintamatematicas?'],
    ['colors',250,'Yo que tu repasaría los colores'],
    ['numbers',250,'¿Cómo llevas los números en inglés?'],
    ['school',250,'¿Sabes como se dice en inglés las cosas del cole?'],
    ['calculator',250,'Esas matemáticas...'],
  ]
  alerts_games.each do |al_game|
    game = Game.all

    better = game.better(al_game[0])[0].to_i #toque esta linea, me daba un error, puse to_i
    me = game.score(al_game[0], id)[0].to_i || 0 #toque esta linea, me daba un error, puse to_i

        
    if((better - me) >= al_game[1])
      alerts = Alert.count(:to_user => id, :game => al_game[0], :status => false)
      alerts_mark = Alert.all(:to_user => id, :game => al_game[0], :status => true)
      if(alerts_mark.length != 0)
        newest = alerts_mark.all(:order => [:created_at.desc], :limit => 1)
        diference =  TimeDifference.between(newest[0].created_at,Time.now).in_days
        if(alerts == 0 && diference > 7)
          Alert.create(:to_user => id, :game => al_game[0], :message => al_game[2], :status => false, :created_at => Time.now)
        end
      else
        if(alerts == 0)
          Alert.create(:to_user => id, :game => al_game[0], :message => al_game[2], :status => false, :created_at => Time.now)
        end
      end
    end
  end
end

get '/puntuation' do 
	if current_user
		@titulo = "Sección de Calificaciones"

		@alerts = Alert.all(:to_user => current_user.id.to_s, :status => false)

	    user = User.first(:username => session[:username])
	    @game = Game.all(:user => user)


	    @usuarios = Hash.new
	    
	    @numeros =Hash.new
	    @calculadora= Hash.new
	    @colores= Hash.new
	    @memory= Hash.new
	    @pinta= Hash.new
	    @ingles= Hash.new
	    @podio= Hash.new

	     puts "-- PODIO --"
	     users = @game.podio()
	     contador = 0

	     users.each do |i|
	     	puts "#{i.usuario} -- #{i.total_score}"
	     	@podio[i.usuario.to_s] = i.total_score.to_i
	     	contador=contador+1;

	     	if (contador >= 3)
	    		break
	    	end
	     end	


	     puts "-- ESTADISTICAS DEL USUARIO --"

	    users = @game.puntos(user.username)
		users.each do |i|
			#puts "#{i.juego} -- #{i.total_score}"
			@usuarios[i.juego.to_s] = i.total_score.to_i
			#puts "#{ @usuarios[i.juego]}"
		end

	    puts "-- ESTADISTICAS NUMBERS --"

	    users = @game.puntos_juego("numbers")
	    contador = 0

	    users.each  do |i|
	    	#puts "#{contador}"
	    	#puts "#{i.usuario} -- #{i.total_score}"
		    @numeros[i.usuario.to_s] = i.total_score.to_i

	    	contador=contador+1;

	    	if (contador >= 3)
	    		break
	    	end
	    end


	    puts "-- ESTADISTICAS CALCULATOR--"

	    users = @game.puntos_juego("calculator")
	    contador = 0

	    users.each  do |i|
	    	#puts "#{i.usuario} -- #{i.total_score}"
	      	@calculadora[i.usuario.to_s] = i.total_score.to_i

	      	contador=contador+1;

	    	if (contador >= 3)
	    		break
	    	end

	    end

	    puts "-- ESTADISTICAS COLORS--"

	    users = @game.puntos_juego("colors")
	    contador = 0

	    users.each  do |i|
	    	#puts "#{i.usuario} -- #{i.total_score}"
	      	@colores[i.usuario.to_s] = i.total_score.to_i

	      	contador=contador+1;

	    	if (contador >= 3)
	    		break
	    	end
	    end

	    puts "-- ESTADISTICAS MEMORIA--"

	    users = @game.puntos_juego("memoria")
	    contador = 0

	    users.each  do |i|
	    	#puts "#{i.usuario} -- #{i.total_score}"
		    @memory[i.usuario.to_s] = i.total_score.to_i
		    #puts "#{ @usuarios[i.juego]}"

		    contador=contador+1;

	    	if (contador >= 3)
	    		break
	    	end
	    end

	    puts "-- ESTADISTICAS PINTAMATEMATICAS--"

	    users = @game.puntos_juego("pintamatematicas")
	    contador = 0

	    users.each  do |i|
	    	#puts "#{i.usuario} -- #{i.total_score}"
	      	@pinta[i.usuario.to_s] = i.total_score.to_i
	      	#puts "#{ @usuarios[i.juego]}"

	      	contador=contador+1;

	    	if (contador >= 3)
	    		break
	    	end
	    end

	    puts "-- ESTADISTICAS SCHOOL--"
	    contador = 0

	    users = @game.puntos_juego("school")
	    users.each  do |i|
	    	#puts "#{i.usuario} -- #{i.total_score}"
	      	@ingles[i.usuario.to_s] = i.total_score.to_i
	      	#puts "#{ @usuarios[i.juego]}"

	      	contador=contador+1;

	    	if (contador >= 3)
	    		break
	    	end
	    end


	    haml :puntuation, :layout => :index

	else
		redirect '/'
	end

end

get '/settings' do

	if current_user

		@alerts = Alert.all(:to_user => current_user.id.to_s, :status => false)
		haml :settings, :layout => :index
	else
		redirect '/'
	end

end

post '/settings' do
	cuser = params[:cuser]

	consulta = User.first(:username => cuser)

	if consulta
		@error_existe = true

		haml :settings, :layout => :index
	else
		#esta en proceso... tengo que ver como se puede hacer que se cambie la clave primaria en todo.
		puts "cambiar user  === #{cuser}"
		consult = User.first(:name=> current_user.name)
		User.change_user(consult.id, cuser)

		consult = User.first(:username => cuser)

		game = Game.first(:user_id => consult.id)
		if game
			Game.change_user(consult.id, cuser)
		end

		note = Note.first(:user_id => consult.id)

		if note 
			Note.change_user(consult.id, cuser)
		end

		mensaje = Message.first(:user_id => consult.id)
		if mensaje
			Message.change_user(consult.id, cuser)
		end
		

		session[:username] = consult.username
		session[:user_id] = consult.id
		
		redirect '/settings'
	end
end

get '/borrar' do
	if current_user
		user_d = User.get(current_user.id, current_user.username)
		puts "#{user_d.name}"
		user_d.destroy
		redirect '/'
	else
		redirect '/'
	end
end

not_found do
  redirect '/'
end
