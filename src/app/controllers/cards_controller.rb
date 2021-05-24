class CardsController < ApplicationController
    before_action :authenticate_user!, only: [:new, :create, :delete, :edit, :update]
    before_action :get_logged_in_user, only: [:new, :index, :show, :create, :edit, :update]
    before_action :get_card_from_params, only: [:show, :destroy, :edit, :update]
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
        if user_signed_in?
            session = Stripe::Checkout::Session.create(
                payment_method_types: ['card'],
                customer_email: @user[:email],
                line_items: [{
                    name: @card.name,
                    description: "TCboard: #{@card.name} - #{@condition}: $#{@card.price}",
                    amount: (@card.price * 100).to_i,
                    currency: 'aud',
                    quantity: @card.qty
                }],
                payment_intent_data: {
                    metadata: {
                        card_id: @card.id
                    }
                },
                success_url: "#{root_url}payments/success?cardId=#{@card.id}",
                cancel_url: "#{root_url}cards"
            )
            @session_id = session.id
        end
    end

    def index
        @cards = Card.order('id DESC')
    end

    def edit
        if @card.user != @user
            flash.now[:errors] = "You can't edit another user's listing"
            render action: 'show'
        end
    end

    def update
        if @card.user != @user
            flash.now[:errors] = "You can't edit another user's listing"
            redirect_to @card
        else
            if @card.update(card_params)
                flash.now[:errors] = "Updated successfully"
                render action: 'show'
            else
                flash.now[:errors] = @card.errors.full_messages
                render action: 'show'
            end
        end
    end

    def destroy
        if @card.user == current_user
            @card.destroy
            redirect_to cards_path
        else
            flash.now[:errors] = "You can't delete a card you don't own"
            render action: 'index'
        end
    end

    def create
        @card = Card.new(card_params)
        if @card.save
            redirect_to @card
        else
            flash.now[:errors] = @card.errors.full_messages
            render action: 'new'
        end
    end

    private

    def card_params
        fields = params.require(:card).permit(:name, :price, :condition, :user_id, :qty)
        fields[:user] = current_user
        return fields
    end

    def get_card_from_params
        @card = Card.find(params[:id])
    end
end
