---
layout: post
title:  "Storing Credit Cards with Stripe"
date:   2016-09-05 21:37:32 -0400
categories: jekyll update
excerpt_separator: <!-- excerpt -->

---
Stripe makes it very easy for developers to process payments in their Rails apps.

However, models and controllers can easily become overwrought with logic. We'll export this logic to service objects each designed to perform one particular task. Service objects are simply specialized classes designed to perform

<!-- excerpt -->
We'll instantiate
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
