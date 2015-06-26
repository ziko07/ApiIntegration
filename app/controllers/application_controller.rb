class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_filter :configure_permitted_parameters, if: :devise_controller?
  protect_from_forgery with: :exception

  def after_sign_in_path_for(resource)
    dashboard_path()
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(:name, :zip, :email, :image, :password, :password_confirmation)
    end
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:name, :country, :zip, :username, :image, :email, :password, :password_confirmation)
    end
    devise_parameter_sanitizer.for(:sign_in) do |u|
      u.permit(:username, :email, :password)
    end
  end
end
