class Api::V1::WebhooksController < ApplicationController
  skip_before_action :authenticate_request

  def create
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    endpoint_secret = Rails.application.credentials.dig(:stripe, :webhook_signing_secret)
    event = nil

    begin
      event = Stripe::Webhook.construct_event(
        payload, sig_header, endpoint_secret
      )
    rescue JSON::ParserError => e       # Invalid payload
      render json: { error: { message: e }}, status: 400
      return
    rescue Stripe::SignatureVerificationError => e # Invalid signature
      render json: { error: { message: e }}, status: 400
      return
    end

    # Handle the event
    case event.type
    when 'customer.created'
      email = event.data['email'] # Get email from the event
      user = User.find_by(email: email) # Find user by email
      
      if user # If user is found, update stripe_id
        response = Stripe::Customer.create(email: email)
        user.update(stripe_id: response.id)
      end
    when 'subscription.created' # Get subscription data from the event
      plan_id = event.data['plan_id']
      customer_id = event.data['customer_id']
      user_id = event.data['user_id']
      status = event.data['status']
      current_period_end = event.data['current_period_end']
      current_period_start = event.data['current_period_start']
      interval = event.data['interval']
      subscription_id = event.data['subscription_id']

      subscription = Subscription.create( # Create a new subscription in the database
        plan_id: plan_id,
        customer_id: customer_id,
        user_id: user_id,
        status: status,
        current_period_end: current_period_end,
        current_period_start: current_period_start,
        interval: interval,
        subscription_id: subscription_id,
        subscription_status: 'trial'
      )
    when 'customer.subscription.updated'
      subscription_id = event.data['object']['id'] # Get subscription ID from the event
      subscription = Subscription.find_by(subscription_id: subscription_id) # Find corresponding subscription by subscription ID

      if subscription
        subscription.plan_id = event.data['object']['items']['data'][0]['plan']['id']
        subscription.status = event.data['object']['status']
        subscription.current_period_end = Time.at(event.data['object']['current_period_end'])
        subscription.current_period_start = Time.at(event.data['object']['current_period_start'])
        subscription.interval = event.data['object']['items']['data'][0]['plan']['interval']
        subscription.save
      end
    when 'customer.subscription.deleted'
      subscription_id = event.data.object.id # Get subscription ID from the event
      subscription = Subscription.find_by(stripe_id: subscription_id) # Find corresponding subscription by subscription ID

      if subscription
        subscription.update!(status: event.data.object.status)
      end
    when 'checkout.session.completed'
      payment_intent_id = event.data['object']['payment_intent']
      user = User.find_by(stripe_id: payment_intent_id)

      if user # Check if the subscription is still in trial period
        if user.subscription_status == 'trial' && user.subscription_trial_end > Time.now
          user.update(subscription_status: 'active')
        end
      end
    end
  end
end
