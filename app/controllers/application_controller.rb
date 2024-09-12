class ApplicationController < ActionController::Base
  include SessionsHelper

  before_action :set_locale

  def default_url_options
    { locale: I18n.locale }
  end

  private

  def require_user
    return if logged_in?

    store_location
    redirect_to login_path, status: :see_other, flash: { danger: 'Login required' }
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
end
