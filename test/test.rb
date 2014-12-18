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
		@uprofile_picture = "profile_picture"
		@ucreated_at = "2014-11-30"
		#Crear un grado
		@table = Grade.first_or_create(:name => @gname, :class => @gclass, :promotion => @gpromotion)
		@grade = Grade.first(:name => @gname)
		#incluir usuarios en el grado
		@user = User.first_or_create(:name => @uname, :last_name => @ulast_name, :username => @uusername, :profile_picture => @uprofile_picture, :created_at => Time.now, :grade => @grade)
		@name = User.first(:name => @uname)

		#Creando mensajes
		@uname2 = "name2"
		@uusername2 = "username2"
		@ulast_name2 = "last_name2"
		@user2 = User.first_or_create(:name => @uname2, :last_name => @ulast_name2, :username => @uusername2, :profile_picture => @uprofile_picture, :created_at => Time.now, :grade => @grade)

		@asunto = "asunto"
		@mensaje = "mensaje"
		@message = Message.first_or_create(:from_user => @uusername,:description => @asunto, :message => @mensaje, :created_at =>Time.now, :status => true, :tipo => true)

		#Relación de mensajes
		@relationship = Relationship.first_or_create(:from_username => @uusername, :to_username => @uusername2)

		#Crear nota
		@note = Note.first_or_create(:name => @asunto, :description => @message, :created_at => Time.now, :finish_at => Time.now, :status => true)

	end

	#GRADO

	it "El nombre del grado es gname" do
		assert_equal @gname, @grade.name
	end

	#USUARIO

	it "El usuario es name" do
		assert_equal @uname, @name.name
	end

	it "El username del usuario es username"
		assert_equal @uusername, @name.username
	end

	it "El usuario pertenece al grado gname"
		assert_equal @gname, @name.grade.name
	end

	#MENSAJES

	it "El mensaje viene del usuario username"
		assert_equal @uusername, @message.from_user
	end

	it "El mensaje tiene asunto"
		assert_equal @asunto, @message.description
	end

	it "El mensaje tiene contenido"
		assert_equal @mensaje, @message.message
	end
	
	#RELACION DE MENSAJES

	it "El mensaje tiene destinatario username2"
		assert_equal @uusername2, @relationship.to_username
	end

	it "El mensaje viene del usuario username"
		assert_equal @uusername, @relationship.from_username
	end

	#NOTAS

	it "La nota tiene un título"
		assert_equal @asunto, @note.name
	end

	it "La nota tiene una descripcion"
		assert_equal @message, @note.description
	end



end