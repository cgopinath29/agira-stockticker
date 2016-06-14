require 'test_helper'

class AdminControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get process_csv" do
    get :process_csv
    assert_response :success
  end

  test "should get create" do
    get :create
    assert_response :success
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get show" do
    get :show
    assert_response :success
  end

end
