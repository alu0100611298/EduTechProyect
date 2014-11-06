ENV['RACK_ENV'] = 'test'
require 'minitest/autorun'
require 'rack/test'
require_relative '../app'

describe "shortened urls" do

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
		@ucreated_at = ""
		#Crear un grado
		@table = Grade.first_or_create(:name => @gname, :class => @gclass, :promotion => @gpromotion)
		@grade = Grade.first(:name => @gname)
		#incluir usuarios en el grado
		@user = User.first_or_create(:name => @uname, :last_name => @ulast_name, :username => @uusername, :profile_picture => @uprofile_picture, :created_at => Time.now, :grade => @grade)
		@name = User.first(:name => @uname)
	end

	it "El nombre del grado es gname" do
		assert_equal @gname, @grade.name
	end

	it "El usuario es name" do
		assert_equal @uname, @name.name
	end
	
end