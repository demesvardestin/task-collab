require 'bcrypt'
require 'sinatra/activerecord'
require 'active_record'

class Task < ActiveRecord::Base
	has_and_belongs_to_many :users
	has_many :task_updates
	
	def task_users
	    TaskUser.where(task_id: id)
	end
	
	def status
		done ? 'completed' : 'incomplete'
	end
	
	def _belongs_to?(user)
		return false if !user
		user_id == user.id
	end
end
