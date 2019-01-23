require 'bcrypt'
require 'sinatra/activerecord'
require 'active_record'

class Task < ActiveRecord::Base
	belongs_to :user
end
