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

  def payment_paypal
    amount = params[:amount].to_i
    quantity = params[:quantity].to_s
   ActiveMerchant::Billing::Base.mode = :test
    express_getway = ActiveMerchant::Billing::PaypalExpressGateway.new(
        login: "zikoku07-facilitator_api1.gmail.com",
        password: "77DPK9X965F3JW4Z",
        signature: "A85Hr-KISUz.LRffVOzrZps10CGNAUlG7tNjw9UETuohRAhNth1bGHU5"
    )


  response = express_getway.setup_purchase(amount,
                                                {cancel_return_url: payment_cancel_url,
                                                return_url: payment_success_url,
                                                currency: "USD",
                                                allow_guest_checkout: true,
                                                items: [{name: "Order", description: "Order description", quantity: "1", amount: amount}]}
      )
      redirect_to express_getway.redirect_url_for(response.token)

  end

  def paypal_success
    details = EXPRESS_GATEWAY.details_for(params[:token])
  end

  def paypal_cancel

  end

  def payment_with_paypal

  end

  def payment_with_stripe

  end

  def payment_stripe
    transaction = ActiveMerchant::Billing::StripeGateway.new(:login => 'sk_test_WMwFf4Euu4Hi6570qcEFy1na')
      amount = params[:amount].to_i
    paymentInfo = ActiveMerchant::Billing::CreditCard.new(
        :number             => params[:card_no],
        :month              => params[:expiration_month],
        :year               => params[:expiration_year],
        :verification_value => "411")

    purchaseOptions = {:billing_address => {
        :name     => params[:name],
        :address1 => params[:address],
        :city     => params[:city],
        :zip      => params[:zip]
    }}

    response = transaction.purchase((amount * 100).to_i, paymentInfo, purchaseOptions)
    puts('<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<')
    puts(response.inspect)
    puts('<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<')
    if response.success? then

    end
  end

end
