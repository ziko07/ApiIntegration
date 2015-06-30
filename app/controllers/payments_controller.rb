class PaymentsController < ApplicationController
  def index
  end

  def new
    @payment = Payment.new
  end

  def create
    ActiveMerchant::Billing::Base.mode = :test

    gateway = ActiveMerchant::Billing::TrustCommerceGateway.new(
        :login => 'TestMerchant',
        :password => 'password')
  payment_params = params[:payment]
# ActiveMerchant accepts all amounts as Integer values in cents
    @amount = payment_params[:amount].to_i

# The card verification value is also known as CVV2, CVC2, or CID
    credit_card = ActiveMerchant::Billing::CreditCard.new(
        :first_name => payment_params[:first_name],
        :last_name => payment_params[:last_name],
        :number => payment_params[:credit_card_number],
        :month => payment_params[:expiration_month], #for test cards, use any date in the future
        :year => payment_params[:expiration_year],
        :verification_value => '000')

# Validating the card automatically detects the card type
    if credit_card.validate.empty?
      # Capture $10 from the credit card
      response = gateway.purchase(@amount, credit_card)

      if response.success?
        @result = 'OK'
        puts "Successfully charged $#{sprintf("%.2f", @amount / 100)} to the credit card #{credit_card.display_number}"
      else
        @result = @response.message
        raise StandardError, @response.message

      end
    end

  end

end
