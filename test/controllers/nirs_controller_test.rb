require 'test_helper'

class NirsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @nir = nirs(:one)
  end

  test "should get index" do
    get nirs_url
    assert_response :success
  end

  test "should get new" do
    get new_nir_url
    assert_response :success
  end

  test "should create nir" do
    assert_difference('Nir.count') do
      post nirs_url, params: { nir: { assessment1_id: @nir.assessment1_id, assessment2_id: @nir.assessment2_id, assessment3_id: @nir.assessment3_id, name: @nir.name, university_id: @nir.university_id, v: @nir.v } }
    end

    assert_redirected_to nir_url(Nir.last)
  end

  test "should show nir" do
    get nir_url(@nir)
    assert_response :success
  end

  test "should get edit" do
    get edit_nir_url(@nir)
    assert_response :success
  end

  test "should update nir" do
    patch nir_url(@nir), params: { nir: { assessment1_id: @nir.assessment1_id, assessment2_id: @nir.assessment2_id, assessment3_id: @nir.assessment3_id, name: @nir.name, university_id: @nir.university_id, v: @nir.v } }
    assert_redirected_to nir_url(@nir)
  end

  test "should destroy nir" do
    assert_difference('Nir.count', -1) do
      delete nir_url(@nir)
    end

    assert_redirected_to nirs_url
  end
end
