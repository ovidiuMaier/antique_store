class PagesController < ApplicationController
  skip_before_action :require_login, only: [:home, :about, :contact, :help]
  def home
  end

  def help
  end

  def about
  end

  def contact
  end

end
