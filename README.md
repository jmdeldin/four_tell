# FourTell
[![Build Status](https://travis-ci.org/TheClymb/four_tell.png?branch=master)](https://travis-ci.org/TheClymb/four_tell)
[![Code Climate](https://codeclimate.com/github/TheClymb/four_tell.png)](https://codeclimate.com/github/TheClymb/four_tell)

Ruby API bindings for the [4-Tell](http://www.4-tell.com/)
personalization service.

## Installation

FourTell supports Ruby 2.0+. Add this line to your application's
Gemfile:

    gem 'four_tell'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install four_tell

## Usage

See the
[documentation](http://rubydoc.info/github/TheClymb/four_tell/frames)
for more details.

```ruby
require 'four_tell'
ft = FourTell.new('username', 'password', 'your_four_tell_client_alias')

# see FourTell::Request for more details
req = ft.build_request
req.customer_id = 1

# fetch a list of recommended product IDs
ft.recommendations(req)
```

## Contributing

1. [Fork it](http://github.com/TheClymb/four_tell/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Author

Built at [The Clymb](http://www.theclymb.com) by

- [Jon-Michael Deldin](https://github.com/jmdeldin)
- [Chris Kuttruff](https://github.com/ckuttruff)
- [Max Justus Spransy](https://github.com/maxjustus)

PS: [We're hiring!](http://www.theclymb.com/careers)
