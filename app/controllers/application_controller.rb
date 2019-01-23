require 'active_support/all'
require 'sinatra/base'
require 'rack-flash'
require_all 'app'

class ApplicationController < Sinatra::Base
    enable :sessions
    use Rack::Flash, :sweep => true
    helpers ApplicationHelper
    
    configure do
        set :server, :puma
        set :views, 'app/views'
        set :public_dir, "public"
        set :database, "sqlite3:db/development.sqlite3"
        set :sessions, :expire_after => 2592000
    end
    
    before do
        @user = current_user
    end
    
    ## Index
    get '/' do
        @message = "Welcome #{@user.email}!" if @user
        erb :'main/index'
    end
    
    ## Tasks Index
    get '/tasks' do
        is_allowed? @user
        
        @tasks = @user.tasks
        erb :'tasks/index'
    end
    
    ## Tasks Show
    get '/tasks/:id' do
        @task = Task.find_by(id: params[:id])
        if @task.nil?
            redirect '/'
            flash[:notice] = "Page not found"
        end
        
        erb :'tasks/show'
    end
    
    ## New Task
    get '/new' do
        is_allowed? @user
        
        @task = Task.new
        erb :'tasks/new'
    end
    
    ## Create Task
    post '/tasks' do
        is_allowed? @user
        
        @task = Task.new(content: params[:content])
        @task.save!
        
        redirect "/tasks/#{@task.id}"
        flash[:notice] = "Task created!"
    end
    
    ## Registration - GET
    get '/register' do
        is_authenticated? @user
        erb :'main/register'
    end
    
    ## Login - GET
    get '/login' do
        is_authenticated? @user
        erb :'main/login'
    end
    
    ## Login - POST
    post '/login' do
        is_authenticated? @user
        
        if @user.nil?
            redirect '/register'
        end
        
        if @user.password == params["password"]
            session['user_id'] = @user.id
            flash[:notice] = "Login sucessful!"
            redirect '/'
        else
            redirect '/login'
        end
    end
    
    ## Registration - POST
    post '/register' do
        is_authenticated? @user
        
        user = User.new(email: params['email'], password: params['password'])
        user.save!
        session['user_id'] = @user.id
        redirect '/'
    end
    
    ## Logout
    post '/logout' do
        session['user_id'] = nil
        redirect '/'
    end
    
end