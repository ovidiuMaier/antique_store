class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  skip_before_action :require_login, only: [:new, :create]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  # GET /users
  # GET /users.json

  def index
    @users = User.paginate(page: params[:page], :per_page => 10)
  end

  def activate
    if @user = User.load_from_activation_token(params[:id])
      @user.activate!
      flash[:success] = 'User was successfully activated.'
      redirect_to log_in_path
    else
      flash[:warning] = 'Cannot activate this user.'
      redirect_to root_path
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
     @user = User.find(params[:id])
     @feed_items = []
    if logged_in?
      if(current_user?(@user))
        @product = current_user.products.build
        @feed_items = current_user.feed.paginate(page: params[:page])
      else
        @product = @user.products.build
        @feed_items = @user.feed.paginate(page: params[:page])
      end
    else
      @product = @user.products.build
      @feed_items = @user.feed.paginate(page: params[:page])
    end
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { login(params[:user][:email], params[:user][:password])
                      redirect_to root_url
                      flash[:success] = 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user
                      flash[:success] = 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url
                    flash[:success] = 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit( :name, :email, :password, :password_confirmation, :picture)
    end

    # Before filters

    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    # confirms an admin user
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
