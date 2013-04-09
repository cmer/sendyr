# Sendyr

A Ruby interface for the wonderful e-mail newsletter application Sendy.

## Installation

Add this line to your application's Gemfile:

    gem 'sendyr'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sendyr

## Usage

		Sendyr.configure do |c|
			c.url     = 'http://my.sendy-install.com'
			c.api_key = '1234567890'
		end

		list_id = 1
		client = Sendyr::Client.new(list_id)
		client.subscribe(email: 'joe@example.org', name: 'Joe Smith', 'FirstName' => 'Joe')  # => true

		client.subscription_status(email: 'joe@example.org') #  => :subscribed

		client.active_subscriber_count  # => 1

		client.unsubscribe(email: 'joe@example.org')  # => true

		client.update_subscription('joe@example.org', email: 'newemail@example.com', name: 'Joe Smith', FirstName => 'Joe')  # => true


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
