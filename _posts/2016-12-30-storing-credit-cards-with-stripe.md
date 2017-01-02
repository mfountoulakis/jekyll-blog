---
layout: post
title:  "Storing Credit Cards with Stripe"
date: 2016-12-30T4:01:00Z
categories: jekyll update
excerpt_separator: <!-- excerpt -->

---
Stripe makes it very easy for developers to process payments in their Rails apps. However, models and controllers can easily become overwrought with logic and there's no standard way to organize the different scenarios of charging  a customer. In this post we'll export this logic to a series of chained service objects, each designed to perform one particular task.
<!-- excerpt -->
#### Setup
Here's some model setup steps, as well as the payment form for Stripe.
```ruby
rails g model payment user:references stripe_token:string last4:string error:string
rails g model user stripe_customer_id:string
rails g model card user:references stripe_token:string last4:string
```
{% gist 142b09b34da642681db68f03bb60f3a5 %}

Stripe supplies us with the code to retrieve a token from the Stripe   API once our form is submitted. You can read more about it in the Stripe docs. [https://stripe.com/docs/custom-form](https://stripe.com/docs/custom-form).
<br>
<br>
#### Step 1: Instantiate the new service
---
The payment controller will handle the token sent from our payment form. After the payment is saved we'll Instantiate our new service.

```ruby
def create
  @payment = Payment.create(payment_params)
  if @payment.save    
    CreateStripeCustomerService.new(@payment)
  end
end
```
{% gist ef042c009f3d53675979a31e194a8739 %}

<br>
#### Step 2: Create a new Stripe customer
---
When the **```CreateStripeCustomer```** service is instantiated, it is passed the payment instance as an argument. Since we're not calling a specific method, we'll call the method **```create_customer```** in the **```CreateStripeCustomer```** service initialize method.

The CreateCustomer service has two responsibilities:
1. Create a new customer if the user's **```stripe_customer_id```** is blank.
2. send the payment to the **```ChargeCreditCard```** service.

Once the customer is created and **```stripe_customer_id```** is assigned to the user, the new service is instantiated, passing the payment as an argument, and calling the method **```charge_or_create_card```**.
```ruby
ChargeCreditCard.new(payment = @payment).charge_or_create_card
```
{% gist 5345fa9f722459db6814e32c2fd57009 %}
<br>
#### Step 3: Charging the credit card.
---
Finally, we can charge the user's credit card. On line 12, we'll find out if the Stripe token has been used. If not, it will be added to the customer's payment sources. Since Stripe tokens can only be used once, we'll be charging the card associated with the Stripe token (the source object), instead of the card token itself. The initialize method of our **```ChargeCreditCard```** service retrieves the card id from the Stripe API and stores it in a variable.

```ruby    
@card = Stripe::Token.retrieve(@payment.stripe_token).card.id
```

{% gist 9129aef9d2ccfd646ce4a876fe9bac59 %}
<br>
#### Step 4: Create a card record
---
Our final service finds or creates a card record based on the payment's stripe token. This will allow us to display the card to the user in the payments form. We'll store the stripe token once again in the card record. Alternatively, you could save the card id directly instead of retrieving it from the token.

{% gist c4886502a9e6c90285b5bd46ce1459fb %}
<br>
#### Step 5: Display the cards to the user.
---
Display the user's cards in the payments form with radio buttons.
```erb
<!-- #app/views/payments/_form.html.erb -->
<div class="form-row">
  <% if @cards %>
    <% @cards.each do |card| %>
      <%= radio_button("payment", "stripe_token", card.stripe_token) %>
      <%= label_tag(:card, card.last4) %>
    <% end %>
  <% end %>
</div>
```
