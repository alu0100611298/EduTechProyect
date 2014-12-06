class User
  include DataMapper::Resource

  property :id, Serial
  property :username, String, :key => true
  property :name, String
  property :last_name, String  
  property :password, String
  property :profile_picture, Text
  property :created_at,  DateTime

  has n, :games, :notes
  #belongs_to :grade
end
class Game
  include DataMapper::Resource
  
  property  :id,		  Serial
  property  :name,        String, :key => true
  property  :score,       Integer
  property  :level,       Integer, :key => true
  property  :created_at,   DateTime

  belongs_to  :user
end

class Note
	include DataMapper::Resource

	property :id, Serial
	property :name, String
	property :description, Text
	property :created_at, DateTime
	property :finish_at, DateTime
	property :status, Boolean

	belongs_to :user
end

class Message
	include DataMapper::Resource

	property :id, Serial
	property :from_user, String
	property :message, Text
	property :created_at, DateTime
	property :status, Boolean

	belongs_to :user
end

class Relationship
	include DataMapper::Resource

	property  :id,		  Serial
	property :from_username, String
	property :to_username, String

	belongs_to :user
end

class Grade
	include DataMapper::Resource

	property :id,	Serial
	property :name, String
	property :class, String
	property :promotion, String

	#has n, :users
end