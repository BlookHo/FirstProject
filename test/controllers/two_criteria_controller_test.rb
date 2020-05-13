require 'test_helper'

class TwoCriteriaControllerTest < ActionDispatch::IntegrationTest
  setup do
    @two_criterium = two_criteria(:one)
  end

  test "should get index" do
    get two_criteria_url
    assert_response :success
  end

  test "should get new" do
    get new_two_criterium_url
    assert_response :success
  end

  test "should create two_criterium" do
    assert_difference('TwoCriterium.count') do
      post two_criteria_url, params: { two_criterium: { criteria1_id: @two_criterium.criteria1_id, criteria2_id: @two_criterium.criteria2_id, uses: @two_criterium.uses } }
    end

    assert_redirected_to two_criterium_url(TwoCriterium.last)
  end

  test "should show two_criterium" do
    get two_criterium_url(@two_criterium)
    assert_response :success
  end

  test "should get edit" do
    get edit_two_criterium_url(@two_criterium)
    assert_response :success
  end

  test "should update two_criterium" do
    patch two_criterium_url(@two_criterium), params: { two_criterium: { criteria1_id: @two_criterium.criteria1_id, criteria2_id: @two_criterium.criteria2_id, uses: @two_criterium.uses } }
    assert_redirected_to two_criterium_url(@two_criterium)
  end

  test "should destroy two_criterium" do
    assert_difference('TwoCriterium.count', -1) do
      delete two_criterium_url(@two_criterium)
    end

    assert_redirected_to two_criteria_url
  end
end
