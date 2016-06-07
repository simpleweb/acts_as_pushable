# ActsAsPushable

[![Build Status](https://semaphoreci.com/api/v1/projects/28a53ae7-389f-4d93-9f8a-51c4b0756cf7/840599/badge.svg)](https://semaphoreci.com/simpleweb/acts_as_pushable)
[![Gem Version](https://badge.fury.io/rb/acts_as_pushable.svg)](https://badge.fury.io/rb/acts_as_pushable)

A gem for Ruby on Rails that makes managing devices and push notifications for both iOS and Android easy and reliable.

## Setup

Add ActsAsPushable to your Gemfile

  ```shell
  gem 'acts_as_pushable'
  bundle install
  ```

or just install it -

  ```shell
  gem install acts_as_pushable
  ```

## Quick start

Run the generator to create the migrations and initializer template -

  ```shell
  rails generate act_as_pushable:install
  rake db:migrate
  ```

This a file at `config/initializers/acts_as_pushable.rb` that you can modify to match your settings. Follow the quick start guides for the platforms that you want to support.

Next add `acts_as_pushable` the following to the model that you want to have devices, this is usually the `User` model. It should look something like this -

  ```ruby
  class User < ActiveRecord::Base
    acts_as_pushable
  end
  ```

## Quick start - iOS

Before we start you'll need a push certificate for both APN Development and APN Production. You can find instructions on how to do this [here](https://developer.apple.com/library/ios/documentation/IDEs/Conceptual/AppDistributionGuide/AddingCapabilities/AddingCapabilities.html#//apple_ref/doc/uid/TP40012582-CH26-SW11).

> **Important:** You should do both production and development and include them in all deployment environments. These relate to the two environments that Apple provide rather than your environments.

Once you have the certificate from Apple, you will need to export your key and the installed certificate as p12 files. Here how you do this -

1. In Keychain Access find your installed certificate
2. Right click the certificate, it should have an arrow next to it if install correctly, then export it.
  ![export](https://cloud.githubusercontent.com/assets/1238468/15851982/5a9bb9e0-2c97-11e6-8407-2e4797673dff.jpg)
3. Next convert the p12 file to a pem file by running the following command.
  ```
  $ openssl pkcs12 -in cert.p12 -out apple_push_notification.pem -nodes -clcerts
  ```
4. The output pem file should be put in one of the following locations depending on it's type -
  - `config/acts_as_pushable/apn/production.pem`
  - `config/acts_as_pushable/apn/development.pem`

> Note: You can change the location that the pem file is loaded stored in the `acts_as_pushable.rb` initializer.

## Quick start - Android

1. Register for GCM (Google Cloud Messaging) at [developers.google.com](https://developers.google.com/cloud-messaging/).
2. Enter your key into the `acts_as_pushable.rb` initializer. You can get this from the [Google API Developer Console](https://console.developers.google.com). It should be entered as such -

  ```ruby
  ActsAsPushable.configure do |config|
    config.gcm_key = 'replace_me_with_your_api_key'
  end
  ```

## Add a device

You can add a device to any model with `acts_as_pushable`. In these examples we'll use a model named `User` as an example.

  ```ruby
  user = User.create
  user.add_device({
    token: 'the_token_generated_by_the_device',
    platform: "ios",
    platform_version: "9.3",
    push_environment: "development",
  })
  ```

## Send a push notification to a user

Sending a push notification to a user will send the message to all of their valid device tokens both on iOS & Android

  ```ruby
  user = User.find(id)
  user.send_push_notification(title: 'My App', message: 'this is a test', options)
  ```

> You might want to consider doing this inside a worker.

## Send a push notification to a specific device

  ```ruby
  user = User.find(id)
  device = user.devices.first

  case device.platform
  when "ios"
    # iOS does not support titles
    user.send_push_notification(message: 'this is a test', options)
  when "android"
    user.send_push_notification(message: 'this is a test', options)
  end
  ```

> You might want to consider doing this inside a worker.

## Apple Feedback Service

Occasionally you'll want to cleanup old tokens that have been invalidated for various reasons. You can do this by running -

```
ActsAsPushable::APN::FeedbackService.run
```

We'd recommnd running this on a daily/weekly cron job.

> Note: With Android this happens at the time of sending a notification, no action is required.

---

## Setup for development

Clone the repository -

  ```shell
  git clone git@github.com:simpleweb/acts_as_pushable.git
  cd acts_as_pushable
  bundle install
  ```

#### Run the specs with RSpec

  ```
  rspec
  ```

## Other useful resources

- [Bullet Proof Push](https://www.youtube.com/watch?v=k5J6t-y1bws) _15 minute talk by [Adam Butler](http://twitter.com/labfoo)_ - The ideas that this gem is based on.
- [simpleweb/ios-development-for-teams](https://github.com/simpleweb/ios-development-for-teams) - A guide by the author of this gem on setting up Certificates, ID's and Provisioning profiles that work well for teams.
- [nomad/houston](https://github.com/nomad/houston) - Powers the APN part of this gem
- [spacialdb/gcm](https://github.com/spacialdb/gcm) - Powers the GCM part of this gem.

## Contributing

This project follows the [GitHub Flow workflow](https://guides.github.com/introduction/flow/). All contributions should be provided as descriptive atomic pull requests.

The gem should be versioned in accordance to [Semantic Versioning 2.0.0](http://semver.org/).
