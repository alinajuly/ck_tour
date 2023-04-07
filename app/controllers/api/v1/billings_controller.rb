class BillingsController < ApplicationController
  skip_before_action :authenticate_request, only: %i[show]
  include ActionView::Layouts
  include ActionController::Rendering

  def show
  end
end
