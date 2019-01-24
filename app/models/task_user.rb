require 'sinatra/activerecord'
require 'active_record'

class TaskUser < ActiveRecord::Base
    
    def user
        User.find_by(id: user_id)
    end
end