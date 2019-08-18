require 'test_helper'

class UserTest < ActiveSupport::TestCase

  setup do
    @user = User.new(name: "Example User", email: "example@example.com", password: "coolcool", password_confirmation: "coolcool" )
  end

  test "User should be valid" do
    assert @user.valid?
  end

  test "User should have name" do
    @user.name = " "
    assert_not @user.valid?
  end

  test "user email should exist" do
    @user.email = " "
    assert_not @user.valid?
  end

  test "user name is not too long" do
    @user.name = "012345678901234567890123456789012345678901234567891"
    assert_not @user.valid?
  end

  test "email is not greath tahn 255 characters" do
    @user.email = "e" * 255 + "@example.com"
    assert_not @user.valid?
  end

  test "email validaiton shoudl accept valid emails" do
    valid_emails = %w[josh@tanda.co to_le@tanda.com st3434543@example.com ]
    valid_emails.each do |email|
       @user.email = email
      assert @user.valid?, "#{email} address is not valid"
    end
  end

  test "email validation should reject invalid emails" do
    invalid_emails = %w[josh@tanda_co.co example@stuff,com cool@tuff!.com]
    invalid_emails.each do |email|
      @user.email = email
      assert_not @user.valid?, "#{email} is valid, it shouldn't be"
      end
  end

  test "non unique emails should not save" do
    user1 = @user.dup
    @user.save

    assert_not user1.valid?
  end

  test "emails with differrent cases should still not save" do
    user1 = @user.dup
    user1.email = @user.email.upcase
    @user.save
    assert_not user1.valid?
  end

  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test "password should be present" do
    @user.password = @user.password_confirmation =  "         "
    assert_not @user.valid?
  end

  test "password should be at least 6 characters" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "user with out digest shouldn't be authenticated" do
    assert_not @user.authenticated?('')
  end
end
