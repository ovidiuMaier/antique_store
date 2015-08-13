require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  include Sorcery::TestHelpers::Rails::Integration

  def setup
    @user = users(:one)
  end

  test "login with invalid information" do
    get log_in_path
    assert_template 'sessions/new'
    post sessions_url, :email => '', :password => ''
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "login with valid information followed by logout" do
    get log_in_path
    post sessions_url, :email => 'whatever@whatever.com', :password => 'secret'
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", log_in_path, count: 0
    assert_select "a[href=?]", log_out_path
    assert_select "a[href=?]", user_path(@user)
    delete log_out_path
    assert_not is_logged_in?
    assert_redirected_to log_in_url
    # Simulate a user clicking logout in a second window.
    delete log_out_path
    follow_redirect!
    assert_select "a[href=?]", log_in_path
    assert_select "a[href=?]", log_out_path,      count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end

  test "login with remembering" do
    post sessions_url, :email => 'whatever@whatever.com', :password => 'secret', :remember_me => '1'
    assert_not_nil cookies['remember_me_token']
  end

  test "login without remembering" do
    post sessions_url, :email => 'whatever@whatever.com', :password => 'secret', :remember_me => '0'
    assert_nil cookies['remember_me_token']
  end
end
