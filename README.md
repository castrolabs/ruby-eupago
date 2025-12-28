# EuPago Ruby SDK

This is a not official Ruby SDK for the EuPago payment gateway.

## Installation

```ruby
gem 'ruby-eupago', '~> 0.2.0'
```

## Usage

First, set your credentials as environment variables:

```bash
export EUPAGO_CLIENT_ID=your_client_id
export EUPAGO_CLIENT_SECRET=your_client_secret
export EUPAGO_API_KEY=your_api_key
```

Then, in your Ruby code:

```ruby
require 'ruby-eupago'

# Example: Create a direct debit authorization
response = EuPago::Api::V1::DirectDebit.authorization({
	"debtor" => {
		"name" => "John Doe",
		"iban" => "PT50123443211234567890172",
		"email" => "john@example.com",
		"address" => {
			"zipCode" => "1234-5678",
			"country" => "PT",
			"street" => "Rua das coisas",
			"locality" => "Lisboa"
		},
		"bic" => "CGDIPTPL"
	},
	"payment" => {
		"autoProcess" => "0",
		"type" => EuPago::Constants::PAYMENT_TYPES[:recurring],
		"date" => "2025-09-15",
		"amount" => 20,
		"periodicity" => EuPago::Constants::RECURRENT_PAYMENT_INTERVALS[:monthly]
	},
	"identifier" => "Test Direct Debit Subscription"
})

puts response
```

For more advanced usage, see the `spec/` directory for real-world examples.

## Testing

```bash
bundle exec rspec
```

## Contributing

I am open to contributions! But with limited time, I cannot promise to respond to every issue or pull request. However, I will do my best to review and merge contributions that align with the project's goals.

If you have some questions about the structure of the project, i am following the [ruby-auth0](https://github.com/auth0/ruby-auth0) structure. They have a great SDK and a well defined structure.
