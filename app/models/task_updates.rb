require 'bcrypt'
require 'sinatra/activerecord'
require 'active_record'

class TaskUpdate < ActiveRecord::Base
    belongs_to :task
    belongs_to :user
end