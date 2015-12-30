require 'test_helper'

class UsersControllerTest < ActionController::TestCase
#  include Sorcery::TestHelpers::Rails::Integration
  include Sorcery::TestHelpers::Rails::Controller

  setup do
    @user = users(:one)
    @other_user = users(:two)
  end

  test "should get index" do
    login_user(user = @user, route = log_in_url)
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count', 1) do
      post :create, user: { email: 'email@email.com', name: 'name', password: 'password', password_confirmation: 'password', activation_state: 'active' }
    end

    assert_redirected_to root_url
  end

  test "should show user" do
    login_user(user = @user, route = log_in_url)
    get :show, id: @user
    assert_response :success
  end

  test "should get edit" do
    login_user(user = @user, route = log_in_url)
    get :edit, id: @user
    assert_response :success
  end

  test "should update user" do
    login_user(user = @user, route = log_in_url)
    patch :update, id: @user, user: { email: @user.email, name: @user.name, password: 'secret', password_confirmation: 'secret' }
    assert_redirected_to user_path(assigns(:user))
  end

  # test "should destroy user" do
  #   login_user(user = @user, route = log_in_url)
  #   assert_difference('User.count', -1) do
  #     delete :destroy, id: @user
  #   end
  #
  #   assert_redirected_to users_path
  # end

  test "should redirect edit when not logged in" do
    get :edit, id: @user
    assert_not flash.empty?
    assert_redirected_to log_in_url
  end

  test "should redirect update when not logged in" do
    patch :update, id: @user, user: { name: @user.name, email: @user.email }
    assert_not flash.empty?
    assert_redirected_to log_in_url
  end

  test "should redirect edit when logged in as wrong user" do
    log_in_as(@other_user)
    get :edit, id: @user
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as(@other_user)
    patch :update, id: @user, user: { name: @user.name, email: @user.email }
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete :destroy, id: @user
    end
    assert_redirected_to log_in_url
  end

  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete :destroy, id: @user
    end
    assert_redirected_to root_url
  end


end
