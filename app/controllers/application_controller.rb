require 'active_support/all'
require 'sinatra/base'
require 'rack-flash'
require 'json'
require_all 'app'

class ApplicationController < Sinatra::Base
    enable :sessions
    use Rack::Flash, :sweep => true
    helpers ApplicationHelper
    Pony.options = {
      :subject => "You've been invited!",
      :via => :sendmail,
      :via_options => {
        :location  => '/usr/sbin/sendmail',
        :arguments => '-t'
      }
    }
    
    configure do
        set :server, :puma
        set :views, 'app/views'
        set :public_dir, "public"
        set :database, "sqlite3:db/development.sqlite3"
        set :sessions, :expire_after => 2592000
    end
    
    before do
        cache_control :public, :must_revalidate
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
        
        @task_users = TaskUser.where(user_id: @user.id)
        @tasks = Task.find(@task_users.map(&:task_id))
        erb :'tasks/index'
    end
    
    ## Tasks Show
    get '/tasks/:id' do
        @task = Task.find_by(id: params[:id])
        @task_users = TaskUser.where(task_id: @task.id)
        
        if @task.nil?
            redirect '/'
            flash[:notice] = "Page not found"
        end
        
        erb :'tasks/show'
    end
    
    ## Tasks Edit
    get '/tasks/:id/edit' do
        @task = Task.find_by(id: params[:id])
        if @task.nil?
            redirect '/'
            flash[:notice] = "Page not found"
        end
        
        is_authorized? @user, @task
        
        erb :'tasks/edit'
    end
    
    ## Tasks Update
    post '/tasks/:id' do
        @task = Task.find_by(id: params[:id])
        is_authorized? @user, @task
        
        @task.update(priority: params['priority'], content: params[:content], user_id: @user.id)
        redirect "/tasks/#{@task.id}"
        flash[:notice] = 'Task successfully updated!'
    end
    
    ## New Task
    get '/new' do
        is_allowed? @user
        
        @task = Task.new
        erb :'tasks/new'
    end
    
    ## Join Task Group As Collaborator
    post '/join_task' do
        is_allowed? @user
        
        @task = Task.find_by(id: params[:id])
        TaskUser.create(user_id: @user.id, task_id: @task.id)
        
        redirect "/tasks/#{@task.id}"
        flash[:notice] = "You have successfully joined this task group!"
    end
    
    ## Send Collaborator Invite
    post '/invite_collaborators' do
        is_allowed? @user
        
        @task = Task.find_by(id: params[:task_id])
        params["emails"].split(',').each do |e|
            Pony.mail :to => e,
                       :body => (erb :email)
            p "mail sent!"
        end
        
        redirect "/tasks/#{@task.id}"
        flash[:notice] = "Your invites have been sent out!"
    end
    
    ## Create Task
    post '/tasks' do
        is_allowed? @user
        
        @task = Task.new(content: params[:content], priority: params[:priority].to_i)
        @task.save!
        TaskUser.create(user_id: @user.id, task_id: @task.id)
        
        redirect "/tasks/#{@task.id}"
        flash[:notice] = "Task created!"
    end
    
    ## Add Update
    post '/add_update' do
        @task = Task.find_by(id: params['task_id'])
        TaskUpdate.create(user_id: @user.id, task_id: @task.id, content: params['content'])
        
        redirect "/tasks/#{@task.id}"
        flash[:notice] = "Update added!"
    end
    
    ## Retrieve Chat Messages
    get '/retrieve_messages' do
        content_type :json
        
        @chat = Chat.find_by(id: params[:chat_id])
        @messages = @chat.messages
        
        JSON.dump @messages
    end
    
    ## Send Chat Messages
    post '/send_message' do
        @recipient = User.find_by(email: params[:recipient_email])
        @chat = Chat.find_by(user_id: @user.id, recipient_id: @recipient.id)
        if @chat.nil?
            @chat = Chat.create(user_id: @user.id, recipient_id: @recipient.id)
        end
        Message.create(chat_id: @chat.id, content: params[:content], user_id: @user.id)
        
        erb :'main/chat.js', :layout => false
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
            redirect(params["redirect"] || '/')
        else
            redirect '/login'
        end
    end
    
    ## Registration - POST
    post '/register' do
        is_authenticated? @user
        
        @user = User.new(email: params['email'], password: params['password'])
        @user.save!
        session['user_id'] = @user.id
        redirect '/'
    end
    
    ## Logout
    post '/logout' do
        session['user_id'] = nil
        redirect '/'
    end
    
end