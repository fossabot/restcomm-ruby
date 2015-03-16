[![Gem Version](http://img.shields.io/gem/v/restcomm-ruby.svg)][gem]
[![Build Status](http://img.shields.io/travis/restcomm/restcomm-ruby.svg)][travis]
[![Code Quality](http://img.shields.io/codeclimate/github/restcomm/restcomm-ruby.svg)][codeclimate]

# restcomm-ruby

A module for using the Restcomm REST API and generating valid [RCML](http://www.restcomm.com/docs/api/twiml/ "RCML - Restcomm Markup Language"). [Click here to read the full documentation.][documentation]

## Installation

To install using [Bundler][bundler] grab the latest stable version:

```ruby
gem 'restcomm-ruby', '~> 3.12'
```

To manually install `restcomm-ruby` via [Rubygems][rubygems] simply gem install:

```bash
gem install restcomm-ruby
```

To build and install the development branch yourself from the latest source:

```bash
git clone git@github.com:restcomm/restcomm-ruby.git
cd restcomm-ruby
make install
```

## Getting Started With REST

### Setup Work

``` ruby
require 'rubygems' # not necessary with ruby 1.9 but included for completeness
require 'restcomm-ruby'

# put your own credentials here
account_sid = 'ACxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
auth_token = 'yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy'

# set up a client to talk to the Restcomm REST API
@client = Restcomm::REST::Client.new account_sid, auth_token

# alternatively, you can preconfigure the client like so
Restcomm.configure do |config|
  config.account_sid = account_sid
  config.auth_token = auth_token
end

# and then you can create a new client without parameters
@client = Restcomm::REST::Client.new
```

### Send an SMS

``` ruby
@client.messages.create(
  from: '+14159341234',
  to: '+16105557069',
  body: 'Hey there!'
)
```

### Send an MMS

``` ruby
@client.messages.create(
  from: '+14159341234',
  to: '+16105557069',
  body: 'Hey there!',
  media_url: 'http://example.com/smileyface.jpg'
)
```

### Do Some Stuff With Calls

``` ruby
# make a new outgoing call
@call = @client.calls.create(
  from: '+14159341234',
  to: '+18004567890',
  url: 'http://example.com/call-handler'
)

# hangup a ringing call, but don't touch it if it's connected
@call.cancel

# if you have the call sid, you can fetch a call object via:
@call = @client.calls.get('CA386025c9bf5d6052a1d1ea42b4d16662')

# redirect an in-progress call
@call.redirect_to('http://example.com/call-redirect')

# hangup a call, no matter whether it is ringing or connected
@call.hangup
```

### List Calls after a certain time

``` ruby
# list calls made or received on or after May 13, 2013
@client.calls.list("start_time>" => "2013-05-13") # Notice we omit the "=" in the "start_time>=" parameter because it is automatically added
```

### Buy a Phone Number

``` ruby
# print some available numbers
@numbers = @client.available_phone_numbers.get('US').local.list(
  contains: 'AWESOME'
)
@numbers.each {|num| puts num.phone_number}

# buy the first one
@number = @numbers[0].phone_number
@client.incoming_phone_numbers.create(phone_number: @number)
```

## Getting Started With Client Capability Tokens

If you just need to generate a Capability Token for use with Restcomm Client, you
can do this:

``` ruby
require 'rubygems' # not necessary with ruby 1.9 but included for completeness
require 'restcomm-ruby'

# put your own account credentials here:
account_sid = 'AC043dcf9844e13758bc3a36a84c29761'
auth_token = '62ea81de3a5b413254eb263595357c69'

# set up
capability = Restcomm::Util::Capability.new account_sid, auth_token

# allow outgoing calls to an application
capability.allow_client_outgoing 'AP89a0180a1a4ddf1da954efca349b7a20'

# allow incoming calls to 'andrew'
capability.allow_client_incoming 'andrew'

# generate the token string
@token = capability.generate
```

There is a slightly more detailed document in the [Capability][capability]
section of the wiki.

## Getting Started With RCML

RCML support is based on the [Builder][builder] library. You can construct a
RCML response like this:

``` ruby
require 'rubygems' # not necessary with ruby 1.9 but included for completeness
require 'restcomm-ruby'

# build up a response
response = Restcomm::RCML::Response.new do |r|
  r.Say 'hello there', voice: 'alice'
  r.Dial callerId: '+14159992222' do |d|
    d.Client 'jenny'
  end
end

# print the result
puts response.text
```

This will print the following (except for the whitespace):

``` xml
<?xml version="1.0" encoding="UTF-8"?>
<Response>
  <Say voice="alice">hello there</Say>
  <Dial callerId="+14159992222">
    <Client>jenny</Client>
  </Dial>
</Response>
```

## Supported Ruby Versions

This library supports and is [tested against][travis] the following Ruby
implementations:

- Ruby 2.2.0
- Ruby 2.1.0
- Ruby 2.0.0
- Ruby 1.9.3
- [JRuby][jruby]
- [Rubinius][rubinius]

## More Information

There are more detailed examples in the included [examples][examples]
directory. Also for thoose upgrading, the [upgrade guide][upgrade] is available in the [restcomm-ruby github wiki][wiki].

[capability]: https://github.com/restcomm/restcomm-ruby/wiki/Capability
[builder]: http://builder.rubyforge.org/
[examples]: https://github.com/restcomm/restcomm-ruby/blob/master/examples
[documentation]: http://restcomm-ruby.readthedocs.org/en/latest
[upgrade]: https://github.com/restcomm/restcomm-ruby/wiki/UpgradeGuide
[wiki]: https://github.com/restcomm/restcomm-ruby/wiki
[bundler]: http://bundler.io
[rubygems]: http://rubygems.org
[gem]: https://rubygems.org/gems/restcomm
[travis]: http://travis-ci.org/restcomm/restcomm-ruby
[codeclimate]: https://codeclimate.com/github/restcomm/restcomm-ruby
[jruby]: http://www.jruby.org
[rubinius]: http://rubini.us