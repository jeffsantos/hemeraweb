require File.dirname(__FILE__) + '/../test_helper'
require 'proof_controller'

# Re-raise errors caught by the controller.
class ProofController; def rescue_action(e) raise e end; end

class ProofControllerTest < Test::Unit::TestCase
  fixtures :theorems

  def setup
    @controller = ProofController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = theorems(:first).id
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'list'
  end

  def test_list
    get :list

    assert_response :success
    assert_template 'list'

    assert_not_nil assigns(:theorems)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:theorem)
    assert assigns(:theorem).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:theorem)
  end

  def test_create
    num_theorems = Theorem.count

    post :create, :theorem => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_theorems + 1, Theorem.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:theorem)
    assert assigns(:theorem).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Theorem.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Theorem.find(@first_id)
    }
  end
end
