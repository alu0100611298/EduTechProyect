# -*- coding: utf-8 -*-
require 'coveralls'
Coveralls.wear!
ENV['RACK_ENV'] = 'test'
require_relative '../app.rb'
require 'rack/test'
require 'selenium-webdriver'
require 'rubygems'
require 'rspec'
include Rack::Test::Methods

def app
	Sinatra::Application
end

describe " Edutech - funcionalidades de las rutas" do
	it "get /" do
		get '/'
		expect(last_response).to be_ok
	end

	it "post de registro" do
		post '/registro', :nombre => "Sergio", :apellidos => "Miguel", :pass => "123456", :pass1 => "123456", :sexo =>"masculino", :username => "sergio"
		last_response.body['Tus últimas notas']
	end

	it "post de registro erroneo - contraseñas distintas" do
		post '/registro', :nombre => "Sergio", :apellidos => "Miguel", :pass => "123456", :pass1 => "asdfgh", :sexo =>"masculino", :username => "sergio"
		last_response.body['Las constraseñas son distintas']
	end

	it "post de registro erroneo - faltan campos" do
		post '/registro', :nombre => "Sergio", :apellidos => "", :pass => "123456", :pass1 => "123456", :sexo =>"masculino", :username => "sergio"
		last_response.body['Faltan datos en el registro']
	end	

	it "post /login" do
		post '/login' , :username => "sergio", :pass => "123456"
		last_response.body['Tus últimas notas']
	end

	it "get /logout" do
		post '/login' , :username => "sergio", :pass => "123456"
		get '/logout'
		last_response.body['Aprende con nosotros, registrate!']
	end

	it "get /puntuation" do
		post '/login' , :username => "sergio", :pass => "123456"
		get '/puntuation'
		last_response.body['Sección de Calificaciones']
	end

	it "get /game" do
		post '/login' , :username => "sergio", :pass => "123456"
		get '/game'
		last_response.body['Sección de Juegos']
	end

	it "get /notes" do
		post '/login' , :username => "sergio", :pass => "123456"
		get '/notes'
		last_response.body['Sección de Notas']
	end

	it "get /home" do
		post '/login' , :username => "sergio", :pass => "123456"
		get '/home'
		last_response.body['Tus últimas notas']
	end


end

	