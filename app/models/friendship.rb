require 'bcrypt'
require 'sinatra/activerecord'
require 'active_record'

class Friendship < ActiveRecord::Base
    belongs_to :user
end