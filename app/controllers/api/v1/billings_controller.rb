class Api::V1::BillingsController < ApplicationController
  skip_before_action :authenticate_request, only: %i[show]
  include ActionView::Layouts
  include ActionController::Rendering

  def show
    session = Stripe::BillingPortal::Session.create({
                                                      customer: 'cus_NflddZpu4LW2a5'
                                                    })

    render json: { url: session.url }
  end
end
