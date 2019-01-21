require 'sinatra'
require_relative 'helpers/application_helper.rb'
require_relative 'models/user.rb'
configure do
    set :server, :puma
    mime_type :scss, 'text/sass'
end
enable :sessions

helpers ApplicationHelper

before do
    ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: 'db/development.sqlite3'
    @user = current_user
end

get '/' do
    @message = "Welcome #{@user.email}!" if @user
    erb :index
end

get('/register') { erb :register }
get('/login') { erb :login }

post('/login') do
    if @user.nil?
        redirect '/register'
    end
    if @user.password == params["password"]
        session['user_name'] = params['email']
        redirect '/'
    else
        redirect '/login'
    end
end

post('/register') do
    session['user_name'] = params['email']
    user = User.new(email: params['email'], password: params['password'])
    user.save!
    redirect '/'
end