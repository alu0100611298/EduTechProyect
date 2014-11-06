class User
  include DataMapper::Resource

  property :id, Serial
  property :name, String
  property :last_name, String
  property :username, String
  property :profile_picture, Text
  property :username, String
  property  :created_at,  DateTime

  has n, :games
end
class Game
  include DataMapper::Resource
  
  property  :id,		  Serial
  property  :name,        String
  property  :score,       Integer
  property  :level,       Integer
  property  :update_at,   DateTime

  belongs_to  :user
  end
end