require 'spec_helper'

describe Sendyr::Client do
	before do
		@base_url = 'http://localhost'
		@api_key  = '1234567890'
		@email    = 'john@example.org'
		@list_id  = '1'

		Sendyr.configure do |c|
			c.url     = @base_url
			c.api_key = @api_key
		end
	end

	let(:client) { Sendyr::Client.new(@list_id) }

	describe ".initialize" do
	  it "should properly set instance variables" do
	  	client = Sendyr::Client.new(@list_id)
	  	client.list_id.should  == @list_id
	  	client.base_uri.should == @base_url
	  	client.api_key.should  == @api_key
	  end
	end

	describe "#subscribe" do
		it "raises exception if email is missing" do
			expect {
				client.subscribe(foo: @email)
			}.to raise_error(ArgumentError, 'You must specify :email.')
		end

		it "subscribes the email and passes the other arguments" do
			stub_request(:post, "#{@base_url}/subscribe").
			  with(:body => {"FirstName"=>"John",
			  							 "boolean"=>"true",
			  							 "email"=> @email,
			  							 "list"=>@list_id,
			  							 "name"=>"John Smith"}).
        to_return(:status => 200, :body => "true")

			client.subscribe(email: @email, name: 'John Smith', "FirstName" => "John").should == true
		end

		it "fails when the response message is an error" do
			stub_request(:post, "#{@base_url}/subscribe").
			  with(:body => {"FirstName"=>"John",
			  							 "boolean"=>"true",
			  							 "email"=> @email,
			  							 "list"=>@list_id,
			  							 "name"=>"John Smith"}).
        to_return(:status => 200, :body => "Already subscribed.")

			client.subscribe(email: @email, name: 'John Smith', "FirstName" => "John").should == false
		end
	end

	describe "#unsubscribe" do
		it "raises exception if email is missing" do
			expect {
				client.unsubscribe(foo: @email)
			}.to raise_error(ArgumentError, 'You must specify :email.')
		end

		it "unsubscribes the email" do
			stub_request(:post, "#{@base_url}/unsubscribe").
			  with(:body => {"boolean"=>"true",
			  							 "email"=> @email,
			  							 "list"=>@list_id}).
        to_return(:status => 200, :body => "true")

			client.unsubscribe(email: @email).should == true
		end

		it "fails when the response message is an error" do
			stub_request(:post, "#{@base_url}/unsubscribe").
				with(:body => {"boolean"=>"true",
											 "email"=> @email,
											 "list"=>@list_id}).
        to_return(:status => 200, :body => "Invalid email address.")

			client.unsubscribe(email: @email).should == false
		end
	end

	describe "#subscription_status" do
		it "raises exception if email is missing" do
			expect {
				client.subscription_status(foo: @email)
			}.to raise_error(ArgumentError, 'You must specify :email.')
		end

		it "returns the correct response when email is not in list" do
			body = "Email does not exist in list"

			stub_request(:post, "#{@base_url}/api/subscribers/subscription-status.php").
				with(:body => {"api_key"=> @api_key,
											 "email"  => @email,
											 "list_id"=> @list_id}).
        to_return(:status => 200, :body => body)

      client.subscription_status(email: @email).should == :not_in_list
		end

		it "returns the correct response when other messages are returned" do
			messages = ["Subscribed","Unsubscribed","Unconfirmed","Bounced","Soft Bounced","Complained"]
			expected_responses = [:subscribed, :unsubscribed, :unconfirmed, :bounced, :soft_bounced, :complained]

			messages.each_index do |i|
				stub_request(:post, "#{@base_url}/api/subscribers/subscription-status.php").
					with(:body => {"api_key"=> @api_key,
												 "email"  => @email,
												 "list_id"=> @list_id}).
	        to_return(:status => 200, :body => messages[i])

	      client.subscription_status(email: @email).should == expected_responses[i]
			end
		end
	end

	describe "#active_subscriber_count" do
		it "returns the number of subscribers when the body is an integer" do
			stub_request(:post, "#{@base_url}/api/subscribers/active-subscriber-count.php").
				with(:body => {"api_key"=> @api_key,
											 "list_id"=> @list_id}).
        to_return(:status => 200, :body => "10")

      client.active_subscriber_count.should == 10
		end

		it "returns false when the body is an error message" do
			stub_request(:post, "#{@base_url}/api/subscribers/active-subscriber-count.php").
				with(:body => {"api_key"=> @api_key,
											 "list_id"=> @list_id}).
        to_return(:status => 200, :body => "List does not exist")

      client.active_subscriber_count.should == false
		end

	end
end
