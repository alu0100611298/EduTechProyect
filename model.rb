require 'dm-core'
require 'dm-migrations'

class User
  include DataMapper::Resource

  property :id, Serial
  property :username, String, :key => true
  property :name, String
  property :last_name, String  
  property :password, String
  property :sexo, String
  property :profile_picture, Text
  property :created_at,  DateTime

  has n, :games, :notes

  def self.change_user(id, user)
      DataMapper.repository.adapter.select("UPDATE users SET USERNAME = '#{user}' WHERE id ='#{id}'")
  end
  #belongs_to :grade
end

class Game
  include DataMapper::Resource
  
  property  :id,		  Serial
  property  :name,        String, :key => true
  property  :score,       Integer
  property  :level,       Integer, :key => true
  property  :created_at,   DateTime

  def self.score(game, id)
    DataMapper.repository.adapter.select("SELECT SUM(score) FROM games WHERE name = '" + game + "' AND user_id = '" + id + "' GROUP BY name")
  end

  def self.better_score(id)
    games = DataMapper.repository.adapter.select("SELECT name,SUM(score) AS score FROM games WHERE user_id = '" + id + "' GROUP BY name")
    max = nil
    games.each do |game|
      if max == nil
        max = game
      elsif game.score > max.score
        max = game
      end
    end
    max
  end

  def self.calificaciones()
    DataMapper.repository.adapter.select("SELECT user_username, name, score FROM games ORDER BY user_username")
  end

  def self.puntos(id)
    DataMapper.repository.adapter.select("SELECT name AS juego, SUM(score) AS total_score FROM games WHERE user_username like '#{id}' GROUP BY name")

  end

  def self.puntos_juego(game)
    DataMapper.repository.adapter.select("SELECT user_username AS usuario, SUM(score) AS total_score FROM games WHERE name = '" + game + "' GROUP BY user_username ORDER BY total_score DESC")
  end

  def self.better(game)
    DataMapper.repository.adapter.select("SELECT SUM(score) FROM games WHERE name = '" + game + "' GROUP BY user_id")
  end

  def self.podio()
    DataMapper.repository.adapter.select("SELECT user_username AS usuario, SUM(score) AS total_score FROM games GROUP BY user_username ORDER BY total_score DESC")
  end

  def self.change_user(id, user)
      DataMapper.repository.adapter.select("UPDATE games SET user_username = '#{user}' WHERE user_id ='#{id}'")
  end

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

  def self.change_user(id, user)
      DataMapper.repository.adapter.select("UPDATE notes SET user_username = '#{user}' WHERE user_id ='#{id}'")
  end

	belongs_to :user
end

class Message
	include DataMapper::Resource

	property :id, Serial
	property :from_user, String
	property :description, Text
	property :message, Text
	property :created_at, DateTime
	property :status, Boolean
	property :tipo, Boolean

  def self.change_user(id, user)
      DataMapper.repository.adapter.select("UPDATE users SET user_username = '#{user}' WHERE user_id ='#{id}'")
  end

	belongs_to :user
end

class Relationship
	include DataMapper::Resource

	property  :id,		  Serial
	property :from_username, String
	property :to_username, String

  def self.change_user(id, user)
      DataMapper.repository.adapter.select("UPDATE users SET user_username = '#{user}' WHERE user_id ='#{id}'")
  end
  
	#belongs_to :user
end

class Grade
	include DataMapper::Resource

	property :id,	Serial
	property :name, String
	property :class, String
	property :promotion, String

	#has n, :users
end

class Alert
  include DataMapper::Resource

  property :id, Serial
  property :to_user, String
  property :game, String
  property :message, Text
  property :status, Boolean
  property :created_at, DateTime

end


