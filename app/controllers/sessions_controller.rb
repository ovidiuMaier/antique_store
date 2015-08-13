class SessionsController < ApplicationController
  skip_before_action :require_login, except: [:destroy]

  def new
  end

  def create
    if @user = login(params[:email], params[:password], params[:remember_me])
      flash[:success] = 'Welcome back!'
      redirect_back_or_to @user
    else
      flash.now[:warning] = 'E-mail and/or password is incorrect.'
      render 'new'
    end
  end

  def destroy
    logout
    flash[:success] = 'See you!'
    redirect_to log_in_path
  end

end
