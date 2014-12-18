# -*- coding: utf-8 -*-
require 'coveralls'
Coveralls.wear!
ENV['RACK_ENV'] = 'test'
require_relative '../chat.rb'
require 'test/unit'
require 'minitest/autorun'
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
		post '/login' , :user_log => "sergio", :pass_log => "123456"
		last_response.body['Tus últimas notas']
	end

	