class MainController < ApplicationController

    before_action :authenticate_user!, only: [:account]

    def index
    end

    def account
        @user = current_user
        @id = params[:id]
        @cards = @user.cards
    end

end
