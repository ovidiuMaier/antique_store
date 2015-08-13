require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  include Sorcery::TestHelpers::Rails::Integration
  include Sorcery::TestHelpers::Rails::Controller

  def setup
    @user = User.create(email: 'email@email.com', name: 'name', password: 'password', password_confirmation: 'password', activation_state: 'active')
  end

  test "activation_needed_email" do
    mail = UserMailer.activation_needed_email(@user)
    assert_equal "Account activation", mail.subject
    assert_equal ["email@email.com"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Welcome", mail.body.encoded
  end

  test "activation_success_email" do
    mail = UserMailer.activation_success_email(@user)
    assert_equal "Your account is now activated", mail.subject
    assert_equal ["email@email.com"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Congratulations", mail.body.encoded
  end

end
