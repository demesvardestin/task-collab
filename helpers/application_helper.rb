module ApplicationHelper
    def index(arg)
        "#{arg} from index!"
    end
    
    def current_user
        User.find_by_email(session['user_name'])
    end
end