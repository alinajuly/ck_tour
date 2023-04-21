class Api::V1::PlansController < ApplicationController
  skip_before_action :authenticate_request
  before_action :authenticate_request_stripe
  before_action :current_user
  include ActionView::Layouts
  include ActionController::Rendering

  #GET api/v1/plans
  def show
    @prices = Stripe::Price.list(expand: ['data.product'], limit: 4)

    render 'api/v1/plans/show', layout: false
  end
end
