require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  setup do
    @user = users(:josh)
  end

  test "invalid password can't edit field" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'

    patch user_path(@user), params: { user: {
                            name: "Josh Cameron",
                            email: "josh@tanda.co",
                            password: "joshman",
                            password_confirmation: "duffman" }}
    assert_template 'users/edit'
  end

  test "valid entry is succesful with friendly fowarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)

    name = 'Josh2'
    email = 'josh@workforce.com'

    patch user_path(@user), params: { user: {
                          name: name,
                          email: "josh@workforce.com",
                          password: "password",
                          password_confirmation: "password"}}
  assert_not flash.empty?
  assert_redirected_to @user
  @user.reload
  assert_equal name, @user.name
  assert_equal email, @user.email
  end
end
