require 'bcrypt'
require 'sinatra/activerecord'
require 'active_record'

class User < ActiveRecord::Base
    include BCrypt
    has_many :tasks
    has_many :friendships
    
    def authenticated(_session_)
        _session_['user_id'] == self.id
    end
    
    def password
        @password ||= Password.new(password_hash)
    end
    
    def password=(new_password)
        @password = Password.create(new_password)
        self.password_hash = @password
    end
end