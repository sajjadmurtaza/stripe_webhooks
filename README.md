# Stripe Webhooks Rails Application

This is a simple Rails application that receives and processes events from Stripe. The application is designed to handle subscription-related events such as creating a subscription,  an invoice, and canceling a subscription.

## Requirements

- Ruby 3.3.5
- Rails 8.0.0.beta1
- Stripe account

## Features

- Creating a subscription on stripe.com (via subscription UI) creates a simple subscription record in your database.
- The initial state of the subscription record is 'unpaid'.
- Paying the first invoice of the subscription changes the state of your local subscription record from 'unpaid' to 'paid'.
- Canceling a subscription changes the state of your subscription record to 'canceled'.
- Only subscriptions in the state 'paid' can be canceled.

## Setup

1. **Clone the repository:**

   ```bash
   git clone git@github.com:sajjadmurtaza/stripe_webhooks.git

   cd stripe_webhooks

2. **Install dependencies:**

    ```bash
    bundle install

3. **Set up the database:**

    ```bash
    rails db:setup

    # or run

    rails db:create
    rails db:migrate

4. **Set up environment variables**

    Create a `.env` file in the root of your project and add your Stripe credentials:

    Please check `.env.template`

    ```bash
    STRIPE_WEBHOOK_SECRET=<your_stripe_webhook_secret>
    TOLERANCE=500

5. **Run the server:**
    ```bash
    rails server

5. **Using Stripe CLI to Listen for Webhooks:**

    https://docs.stripe.com/stripe-cli

    ```bash
    stripe listen --forward-to localhost:3000/webhooks/stripe/create

    # or (ngrock URl or domain)

    stripe listen --forward-to https://username.ngrok.io/webhooks/stripe/create

6. **Trigger Webhook Events:**
    ```bash
    stripe trigger customer.subscription.created
    stripe trigger invoice.paid
    stripe trigger customer.subscription.deleted

### Key files (Folder Structure)


    stripe_webhooks/
    ├── app/
    │   ├── controllers/
    │   │   └── webhooks/
    │   │       └── stripe_controller.rb
    │   ├── models/
    │   │   └── subscription.rb
    │   ├── services/
    │   │   └── stripe/
    │   │       └── events.rb
    │   │   └── subscriptions/
    │   │       └── status.rb
    ├── config/
    │   ├── routes.rb
    ├── db/
    │   ├── migrate/
    │   ├── schema.rb
    ├── spec/
    │   ├── controllers/
    │   │   └── webhooks/
    │   │       └── stripe_controller_spec.rb
    │   ├── fixtures/
    │   │   ├── stripe_event_created.json
    │   │   ├── stripe_event_paid.json
    │   │   ├── stripe_event_deleted.json
    │   ├── models/
    │   │   └── subscription_spec.rb
    │   └── support/
    │       └── vcr_setup.rb
    ├── .env
    ├── .gitignore
    ├── Gemfile
    ├── README.md

### Application Flow

Stripe(Create/Pay/Cancel) --------------> Webhooks Controller


Webhooks Controller -------------------> Event Processor

Event Processor ------------------------> Subscription Model

### Webhooks::StripeController

Handles incoming Stripe webhook events and processes them using the `Stripe::Events` service.

### Stripe::Events

Processes Stripe events and updates subscriptions accordingly.

### Subscriptions::Status

Manages subscription status transitions and updates the subscription data.

### Subscription Model

Represents a subscription and its state, with validations and state transition logic.

