require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "account_activation" do
    user = users(:josh)
    user.activation_token = User.new_token
    mail = UserMailer.account_activation(user)
    assert_equal "Activating your account on Joshman.com", mail.subject
    assert_equal ["fixture@tanda.co"], mail.to
    assert_equal ["josh@workforce.com"], mail.from
    assert_match "Hi", mail.body.encoded
    assert_match user.name, mail.body.encoded
    assert_match user.activation_token, mail.body.encoded
    assert_match CGI.escape(user.email), mail.body.encoded
  end

  test "password_reset" do
    user = users(:josh)
    user.reset_token = User.new_token
    mail = UserMailer.password_reset(user)
    assert_equal "Resetting your password.", mail.subject
    assert_equal ["fixture@tanda.co"], mail.to
    assert_equal ["josh@workforce.com"], mail.from
    assert_match "Hi", mail.body.encoded
    assert_match user.reset_token, mail.body.encoded
    assert_match CGI.escape(user.email), mail.body.encoded
  end
end