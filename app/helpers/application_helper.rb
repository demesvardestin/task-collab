module ApplicationHelper
    def current_user
        User.find_by_email(params['email']) or User.find_by(id: session['user_id'])
    end
    
    def authentication_required
        %w(tasks new).each { |u|
            request.path_info == u.prepend('/')
        }
    end
    
    def is_authenticated?(user)
        redirect '/' if user && user.authenticated(session)
    end
    
    def is_allowed?(user)
        redirect '/login' if !user && authentication_required
    end
end