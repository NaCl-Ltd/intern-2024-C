class ApplicationController < ActionController::Base
  before_action :set_locale

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
  include SessionsHelper

  private

  def require_user
    return if logged_in?

    store_location
    redirect_to login_path, flash: { danger: 'Login required' }
  end
end
