class Chat < ActiveRecord::Base
    belongs_to :user
    has_many :messages
    
    def correspondent
        User.find_by(id: recipient_id)
    end
    
    def last_message
        messages.last
    end
end