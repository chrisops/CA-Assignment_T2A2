class CardsController < ApplicationController
    before_action :authenticate_user!, only: [:new, :create, :delete, :edit]
    before_action :get_logged_in_user, only: [:new, :index, :show, :create]
    before_action :get_card_from_params, only: [:show, :destroy, :edit]
    @@card_condition = {
        "NM" => "Near Mint",
        "LP" => "Lightly Played",
        "MP" => "Moderately Played",
        "HP" => "Heavily Played/Damaged"
    }

    def new
        @card = Card.new
    end

    def show
        @condition = @@card_condition[@card.condition]
    end

    def index
        @cards = Card.order('id DESC')
    end

    def destroy
        if @card.user == current_user
            @card.destroy
            redirect_to cards_path
        else
            flash.now[:errors] = "You can't delete a card you don't own"
            redirect_to cards_path
        end
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
        else
            @user = "Guest"
        end
    end

    def card_params
        params.require(:card).permit(:name, :price, :condition, :user_id, :qty)
    end

    def get_card_from_params
        @card = Card.find(params[:id])
    end
end
