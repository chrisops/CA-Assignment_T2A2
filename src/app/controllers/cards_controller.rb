class CardsController < ApplicationController
    before_action :authenticate_user!, only: [:new, :create]
    before_action :get_logged_in_user, only: [:new, :index, :show, :create]

    def new
        @card = Card.new
    end

    def show
        @card = Card.find(params[:id])
    end

    def index
        @cards = Card.order('id DESC')
    end

    def create
        fields = card_params
        fields[:user] = @user
        @card = Card.new(fields)
        if @card.save
            redirect_to @card
        else
            flash.now[:errors] = @card.errors.full_messages
            render action: 'new'
        end
    end

    private

    def get_logged_in_user
        if user_signed_in?
            @user = current_user
        end
    end

    def card_params
        params.require(:card).permit(:name, :price, :condition, :user_id, :qty)
    end

end
