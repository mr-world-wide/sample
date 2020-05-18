require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  setup do
    @user = User.create!(name: "Josh Cameron", email: "Josh@tanda.co", password: "stuff1234", password_confirmation: "stuff1234")
    @other_user = users(:stirling)
  end

  test "should redirect index when user not logged in" do
    get users_path
    assert_redirected_to login_url
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end

  test "should show user" do
    assert @user.valid?
    @user.activate
    get user_path(@user.id)
    assert_response :success
    assert_template 'show'
  end

  test "View title should include users name" do
    @user.activate
    get user_path(@user.id)
    assert_select "title", "#{@user.name} | Daoboard: The roundabout way to getting things done"
  end

  test "Logout user should be redirect when editing profile" do
  get edit_user_path(@user)
  assert_not flash.empty?
  assert_redirected_to login_url
  end

  test "Should redirect logout users when updating profile" do
    patch user_path(@user), params: {user: { name: @user.name,
                                           email: @user.email }}
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "user should not be able to edit other users" do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "Should redirect update when logged in as wrong user" do
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { name: @user.name,
                                            email: @user.password}}
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "Should redirect user when try to delete but not logged in" do
    assert_no_difference 'User.count' do
      delete user_path(@other_user)
    end
    assert_redirected_to login_url
  end

  test "Should not allow non admin not to " do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to root_url
  end
end
