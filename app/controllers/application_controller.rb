class ApplicationController < ActionController::Base
  #include Authentication
  protect_from_forgery


  rescue_from CanCan::AccessDenied do |exception|
    redirect_to "/aticell", :alert => exception.message
  end

  def current_ability
    @current_ability ||= Ability.new(current_admin_user)

  end

  def set_admin_locale
    I18n.locale = :"pt-BR"
  end

end
