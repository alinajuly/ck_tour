class Api::V1::WebhooksController < ApplicationController
  skip_before_action :authenticate_request

  def create
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    endpoint_secret = Rails.application.credentials.dig(:stripe, :webhook_signing_secret)

    begin
      event = Stripe::Webhook.construct_event(
        payload, sig_header, endpoint_secret
      )
    rescue JSON::ParserError => e
      render json: { error: { message: e } }, status: 400
      return
    rescue Stripe::SignatureVerificationError => e
      render json: { error: { message: e } }, status: 400
      return
    end

    # Handle the event
    case event.type
    when 'customer.subscription.created'
      handle_subscription_created(event)
    when 'customer.subscription.updated'
      handle_subscription_updated(event)
    when 'customer.subscription.deleted'
      handle_subscription_deleted(event)
    else
      puts "Unhandled event type: #{event.type}"
    end
  end

  private

  def handle_subscription_created(event)
    subscription = event.data.object
    customer = Stripe::Customer.retrieve(event.data.object.customer)
    user = User.find_by(email: customer.email)
    user.update(stripe_id: customer.id)

    Subscription.create(
      user:,
      customer_id: user.stripe_id,
      status: subscription.status,
      current_period_end: Time.at(subscription.current_period_end),
      current_period_start: Time.at(subscription.current_period_start),
      subscription_id: subscription.id,
      created_at: Time.at(subscription.created),
      updated_at: Time.at(subscription.created),
      plan_id: subscription.plan.id,
      interval: event.data.object.plan.interval
    )

    return unless ['trialing', 'active'].include?(subscription.status)
      user = User.find_by(email: customer.email)
      return unless user
        user.update(role: 'partner')
        UserMailer.user_partner(user).deliver_later
      
    
  end

  def handle_subscription_updated(event)
    subscription_id = event.data.object.id
    subscription = Subscription.find_by(subscription_id:)
    customer = Stripe::Customer.retrieve(event.data.object.customer)

    if subscription
      subscription.plan_id = event.data.object.items.data[0].plan.id
      subscription.status = event.data.object.status
      subscription.current_period_end = event.data.object.current_period_end
      subscription.current_period_start = event.data.object.current_period_start
      subscription.interval = event.data.object.items.data[0].plan.interval
      subscription.save
    end

    if ['unpaid', 'past_due', 'canceled', 'incomplete', 'incomplete_expired', 'paused'].include?(subscription.status)
      user = User.find_by(email: customer.email)
      if user
        user.update(role: 'tourist')
        UserMailer.user_tourist(user).deliver_later
        user.accommodations.unpublished! if user.accommodations.present?
        user.tours.unpublished! if user.tours.present?
        user.caterings.unpublished! if user.caterings.present?
      end
    end

    return unless ['trialing', 'active'].include?(subscription.status)
      user = User.find_by(email: customer.email)
      return unless user
        user.update(role: 'partner')
        UserMailer.user_partner(user).deliver_later
      
    
  end

  def handle_subscription_deleted(event)
    subscription_id = event.data.object.id
    subscription = Subscription.find_by(subscription_id:)
    customer = Stripe::Customer.retrieve(event.data.object.customer)

    subscription.update!(status: event.data.object.status) if subscription

    unless ['unpaid', 'past_due', 'canceled', 'incomplete', 'incomplete_expired', 'paused'].include?(subscription.status)
  return
end
      user = User.find_by(email: customer.email)
      return unless user
        user.update(role: 'tourist')
        user.accommodations.unpublished! if user.accommodations.present?
        user.tours.unpublished! if user.tours.present?
        user.caterings.unpublished! if user.caterings.present?
      
    
  end
end
