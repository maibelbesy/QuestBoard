require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
 
  test "login with invalid information" do
    get login_path		#Visit the login path.
    assert_template 'sessions/new'	#Verify that the new sessions form renders properly.
    post login_path, session: { email: "", password: "" } #Post to the sessions path with an invalid params hash.
    assert_template 'sessions/new' #Verify that the new sessions form gets re-rendered and that a flash message appears.
    assert_not flash.empty?
    get root_path		#Visit another page
    assert flash.empty?	#Verify that the flash message doesn’t appear on the new page.
  end
end
