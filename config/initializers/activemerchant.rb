if Rails.env == "development"
  ActiveMerchant::Billing::FirstdataE4Gateway.wiredump_device = File.open(Rails.root.join("log","active_merchant.log"), "a+")
  ActiveMerchant::Billing::FirstdataE4Gateway.wiredump_device.sync = true
  ActiveMerchant::Billing::Base.mode = :test

  login = "7k4G28vtvP9n"
  password="876k6LLwQT7tK6F5"
elsif Rails.env == "production"
  login = 'mylogin'
  password='mypassword'
end
GATEWAY = ActiveMerchant::Billing::FirstdataE4Gateway.new({
                                                              login: login,
                                                              password: password
                                                          })