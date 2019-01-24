require 'bcrypt'
require 'sinatra/activerecord'
require 'active_record'

class Task < ActiveRecord::Base
	has_and_belongs_to_many :users
	
	def task_users
	    TaskUser.where(task_id: id)
	end
end
