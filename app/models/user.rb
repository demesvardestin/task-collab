require 'bcrypt'
require 'sinatra/activerecord'
require 'active_record'
require_relative 'task_user.rb'

class User < ActiveRecord::Base
    include BCrypt
    has_and_belongs_to_many :tasks
    
    def authenticated(_session_)
        _session_['user_id'] == id
    end
    
    def task_users
	    TaskUser.where(user_id: id)
	end
	
	def is_in(task)
	    task_users.exists?(task_id: task.id)
	end
    
    def password
        @password ||= Password.new(password_hash)
    end
    
    def password=(new_password)
        @password = Password.create(new_password)
        self.password_hash = @password
    end
end