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
		@name = "name"
		@last_name = "last_name"
		@username = "username"
		@profile_picture = "profile_picture"
		@created_at = ""

		@table = Grade.first_or_create(:name => @gname, :class => @gclass, :promotion => @gpromotion)
		@grade = Grade.first(:name => @gname)
		#@user = User.new(:name => @name, :last_name => @last_name, :username => @username, :profile_picture => @profile_picture, :created_at => Time.now, :grade => @grade)
		#@user.save
		#@name = User.first(:name => @name)
	end

	it "El nombre del grado es gname" do
		assert_equal @gname, @grade.name
	end
	
end