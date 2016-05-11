# Ruboty::Attend

Management attendance.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ruboty-attend'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ruboty-attend

## Usage

```
ruboty /create_attendance\s?(?<desc>.+?)\z/ - create new attendance
ruboty /close_attendance\s?(?<ch>(\d)+?)\z/ - close attendance
ruboty /absent\s?(?<ch>(\d)+?)\z/ - absent target channel event
ruboty /attend\s?(?<ch>(\d)+?)\z/ - attend target channel event
ruboty /all_attendance\z/ - show all attendance
ruboty /attend_status\s?(?<ch>(\d)+?)\z/ - get state of channel
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Everysick/ruboty-attend. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
