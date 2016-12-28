---
layout: post
title:  "Storing Credit Cards with Stripe"
date:   2016-09-05 21:37:32 -0400
categories: jekyll update
excerpt_separator: <!-- excerpt -->

---
Stripe makes it very easy for developers to process payments in their Rails apps.

However, models and controllers can easily become overwrought with logic and there's no standard way to organize the different scenarios. In this post we'll export this logic to a series of chained service objects, each designed to perform one particular task.

First, lets look at what's needed to charge customers with stipe. Stripe gives you the main components for creating a charge in their documentation https://stripe.com/docs/custom-form . 


<!-- excerpt -->
We'll instantiate our CreateStripeCustomerService in our payment_controller.rb create method
```ruby
def create
  @payment = Payment.create(payment_params)
  if @payment.save
    #our new service is instantiated here, with the new payment record
    CreateStripeCustomerService.new(@payment)
  end
end
def payment_params
  params.fetch(:payment, {}).permit(:stripe_token, :user_id)
end
```

{% gist 02e835ae0f45bea13a7e692606cb998e %}
{% gist d1566486a2e9e039343e46bdb8b043bf %}
{% gist 7e96510fc643062e45ca8631c29ba4ff %}
