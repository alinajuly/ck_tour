
 

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
      render json: { error: { message: e }}, status: 400
      return
    rescue Stripe::SignatureVerificationError => e
      render json: { error: { message: e }}, status: 400
      return
    end

    # Handle the event
    case event.type
    when 'customer.created'
      handle_customer_created(event)
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

  def handle_customer_created(event)
    email = event.data['email'] # Get email from the event
    user = User.find_by(email: email) # Find user by email
      
    if user
      response = Stripe::Customer.create(email: email)
      user.update(stripe_id: response.id)
    end
  end

  def handle_subscription_created(event)
    subscription = event.data.object
    subscription = Subscription.create

    if ['trialling', 'active'].include?(subscription.status)
      user = User.find_by(id: user_id)
      if user
        user.update(role: 'partner')
      end
    end
  end

  def handle_subscription_updated(event)
    subscription_id = event.data.object.id 
    subscription = Subscription.find_by(subscription_id: subscription_id) 

    if subscription
      subscription.plan_id = event.data.object.items.data[0].plan.id
      subscription.status = event.data.object.status
      subscription.current_period_end = Time.at(event.data.object.current_period_end)
      subscription.current_period_start = Time.at(event.data.object.current_period_start)
      subscription.interval = event.data.object.items.data[0].plan.interval
      subscription.save
    end

    if ['unpaid', 'past_due', 'canceled', 'incomplete', 'incomplete_expired', 'paused'].include?(subscription.status)
      user = User.find_by(id: user_id)
      if user
        user.update(role: 'tourist')
      end
    end
  end

  def handle_subscription_deleted(event)
    subscription_id = event.data.object.id 
    subscription = Subscription.find_by(subscription_id: subscription_id)

    if subscription
      subscription.update!(status: event.data.object.status)
    end
  end

    # when 'checkout.session.completed'
    #   payment_intent_id = event.data.object.payment_intent
    #   user = User.find_by(stripe_id: payment_intent_id)

    #   if user # Check if the subscription is still in trial period
    #     if user.subscription_status == 'trial' && user.subscription_trial_end > Time.now
    #       user.update(subscription_status: 'active')
    #     end
    #   end
    # end
end
