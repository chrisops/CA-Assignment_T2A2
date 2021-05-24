class ApplicationController < ActionController::Base

    def get_logged_in_user
        if user_signed_in?
            @user = current_user
        else
            @user = {
                name: "Guest",
                email: "no email"
            }
        end
    end

end
