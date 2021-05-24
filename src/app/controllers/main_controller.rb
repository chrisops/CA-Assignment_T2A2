class MainController < ApplicationController

    before_action :authenticate_user!, only: [:account]
    before_action :get_cards, only: [:index]

    def index
    end

    def account
        @user = current_user
        @user_viewed = User.find(params[:id])
        @cards = @user_viewed.cards
    end

    private

    def get_cards
        @cards = Card.order('id DESC')
    end

end
