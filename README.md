# E-Commerce Website Project

## Development Environment
- Ruby 3.2.2
- Ruby on Rails 7.0.4
- Development Platform: Windows (WSL)

## Project Overview
This is a Ruby on Rails based e-commerce website project that includes both a front-end store and a back-end management system.

### Core Features

#### Front-end Features
1. User System
   - User registration and login
   - Personal account management
   - Multi-role support (Regular users/Administrators)

2. Product Display
   - Product listing
   - Category browsing
   - Product detail pages

3. Shopping Cart System
   - Add products to cart
   - Update product quantities
   - Remove products from cart
   - Clear cart

4. Order System
   - Order creation
   - Order viewing
   - Payment integration (Stripe)
   - Order status tracking

#### Admin Management System
1. Admin Dashboard
   - Statistical overview
   - Recent activity logs

2. Product Management
   - Product list view
   - Add new products
   - Edit product information
   - Product status management

3. User Management
   - User list management
   - User permission control

4. Order Management
   - Order processing
   - Order status updates

## Technology Stack
- Backend: Ruby on Rails
- Frontend: HTML, CSS, JavaScript
- Database: ActiveRecord
- Authentication: Devise
- Admin Panel: ActiveAdmin
- Payment Integration: Stripe

## Project Structure

## Second Chance Treasures

An e-commerce platform for selling used goods.

## Features

- User authentication system
- Admin dashboard for managing products, categories, and orders
- Product catalog with search and filtering
- Shopping cart functionality
- Province-based tax calculation
- Secure checkout with Stripe payment processing
- Order history and tracking
- Responsive design for all devices

## Setup Instructions

1. Clone the repository
2. Run `bundle install` to install dependencies
3. Set up the database with `rails db:create db:migrate db:seed`
4. Start the server with `rails server`

## Stripe Integration Setup

1. Sign up for a Stripe account at https://stripe.com
2. Get your API keys from the Stripe Dashboard
3. Add your Stripe API keys to your Rails credentials:

```bash
# On Windows:
set EDITOR=notepad
rails credentials:edit

# On macOS/Linux:
EDITOR="nano" rails credentials:edit
```

4. Add the following to your credentials file:

```yaml
stripe:
  publishable_key: your_stripe_publishable_key
  secret_key: your_stripe_secret_key
  webhook_secret: your_stripe_webhook_secret
```

5. To set up webhooks for asynchronous payment processing:
   - Go to the Stripe Dashboard > Developers > Webhooks
   - Add an endpoint URL: `https://your-domain.com/stripe/webhook`
   - Select the `checkout.session.completed` event
   - Save and copy the Signing Secret to your credentials

## Test Cards

Use these test cards for making payments in test mode:

- Success: 4242 4242 4242 4242
- Requires Authentication: 4000 0025 0000 3155
- Declined: 4000 0000 0000 9995

Expiration Date: Any future date
CVC: Any 3 digits
ZIP: Any 5 digits

## Testing

Run the test suite with:

```bash
rails test
```

## License

This project is licensed under the MIT License - see the LICENSE file for details.
