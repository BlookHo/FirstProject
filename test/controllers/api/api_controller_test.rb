require 'test_helper'

class Api::ApiControllerTest < ActionDispatch::IntegrationTest
  test "should get next_image" do
    get api_api_next_image_url
    assert_response :success
  end

  test "should get prev_image" do
    get api_api_prev_image_url
    assert_response :success
  end

end
