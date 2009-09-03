require 'test_helper'

class ProofscriptsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:proofscripts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create proofscript" do
    assert_difference('Proofscript.count') do
      post :create, :proofscript => { }
    end

    assert_redirected_to proofscript_path(assigns(:proofscript))
  end

  test "should show proofscript" do
    get :show, :id => proofscripts(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => proofscripts(:one).to_param
    assert_response :success
  end

  test "should update proofscript" do
    put :update, :id => proofscripts(:one).to_param, :proofscript => { }
    assert_redirected_to proofscript_path(assigns(:proofscript))
  end

  test "should destroy proofscript" do
    assert_difference('Proofscript.count', -1) do
      delete :destroy, :id => proofscripts(:one).to_param
    end

    assert_redirected_to proofscripts_path
  end
end
