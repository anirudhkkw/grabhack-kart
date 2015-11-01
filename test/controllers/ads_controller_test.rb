require 'test_helper'

class AdsControllerTest < ActionController::TestCase
  test "should get Search" do
    get :Search
    assert_response :success
  end

end
