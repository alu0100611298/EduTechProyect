require 'coveralls'
Coveralls.wear!
ENV['RACK_ENV'] = 'test'
require 'minitest/autorun'
require 'rack/test'
require_relative '../app'

describe "Edutech" do

	before :all do
		#grade
		@gname = "gname"
		@gclass = "gclass"
		@gpromotion = "promotion"
		#user
		@uname = "name"
		@ulast_name = "last_name"
		@uusername = "username"
		@sexo = "masculino"
		@pass = "12344"
		@uprofile_picture = "foto"
		@ucreated_at = ""
		@uprofile_picture = "profile_picture"
		@ucreated_at = "2014-11-30"

		#Crear un grado
		#@table = Grade.first_or_create(:name => @gname, :class => @gclass, :promotion => @gpromotion)
		#@grade = Grade.first(:name => @gname)
		#incluir usuarios en el grado
		#@user = User.create(:username => @uusername, :name => @uname, :last_name => @ulast_name, :password => @pass, :sexo => @sexo)
		@user = User.first_or_create(:name => @uname, :last_name => @ulast_name, :username => @uusername, :profile_picture => @uprofile_picture, :created_at => Time.now, :sexo => @sexo, :password => @pass)
		@name = User.first(:name => @uname)

		#Creando mensajes
		@uname2 = "name2"
		@uusername2 = "username2"
		@ulast_name2 = "last_name2"
		@user2 = User.first_or_create(:name => @uname2, :last_name => @ulast_name2, :username => @uusername2, :profile_picture => @uprofile_picture, :created_at => Time.now)

		@asunto = "asunto"
		@mensaje = "mensaje"
		#@message = Message.first_or_create(:from_user => @uusername, :message => @mensaje, :created_at =>Time.now, :status => true, :user => @user2,  :description => @asunto,  :tipo => true)
		@message = Message.first_or_create(:from_user => @uusername, :message => @mensaje, :created_at =>Time.now, :status => true, :user =>  @user2,  :description => @asunto,  :tipo => true)
		

		#Relación de mensajes
		#@relationship = Relationship.first_or_create(:from_username => @uusername, :to_username => @uusername2)

		#Crear nota
		@note = Note.first_or_create(:name => @asunto, :description => @mensaje, :created_at => Time.now, :finish_at => Time.now, :status => true, :user => @user2)

	end


	#USUARIO

	it "El usuario es name" do
		assert_equal @uname, @name.name
	end

	it "El username del usuario es username" do
		assert_equal @uusername, @name.username
	end

	#MENSAJES

	it "El mensaje viene del usuario username" do
		assert_equal @uusername, @message.from_user
	end

	it "El mensaje tiene asunto" do
		assert_equal @asunto, @message.description
	end

	it "El mensaje tiene contenido" do
		assert_equal @mensaje, @message.message
	end
	
	#RELACION DE MENSAJES

	/it "El mensaje tiene destinatario username2" do
		assert_equal @uusername2, @relationship.user_username
	end

	it "El mensaje viene del usuario username" do
		assert_equal @uusername, @relationship.from_username
	end/

	#NOTAS

	it "La nota tiene un título" do
		assert_equal @asunto, @note.name
	end

	it "La nota tiene una descripcion" do
		assert_equal @mensaje, @note.description
	end
end
