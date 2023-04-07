class Api::V1::PlansController < ApplicationController
  skip_before_action :authenticate_request, only: %i[show]
  include ActionView::Layouts
  include ActionController::Rendering

  def show
    @prices = Stripe::Price.list(expand: ['data.product'], limit: 4)

    render 'api/v1/plans/show', layout: false
  end
end
