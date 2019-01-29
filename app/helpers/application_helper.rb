module ApplicationHelper
    def current_user
        User.find_by_email(params['email']) or User.find_by(id: session['user_id'])
    end
    
    def authentication_required
        %w(tasks new).each { |u|
            request.path_info == u.prepend('/')
        }
    end
    
    def pluralize(noun, count)
        "#{count} " << (count > 0 ? noun + 's' : noun)
    end
    
    def is_authenticated?(user)
        redirect '/' if user && user.authenticated(session)
    end
    
    def is_allowed?(user)
        redirect '/login' if !user && authentication_required
    end
    
    def is_authorized?(user, task)
        if task.user_id != user.id
            redirect '/'
            flash[:notice] = "You are not allowed to access this page!"
        end
    end
    
    def truncate(string, value)
        string.length <= value ? string : string[0..value] + '...'
    end
    
    def status_color(status)
        case status
        when 'incomplete'
            'status-red'
        when 'complete'
            'status-green'
        end
    end
end