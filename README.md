# LiquerY

This gem was built as part of a project within the Flatiron School's curriculum. LiquerY is a CLI gem that uses a few simple algorithms alongside thecocktaildb.com's API of cocktail ingredients to help the user identify their beverage preferences and learn about new and exciting cocktails. Besides offering some basic search and sort features, LiqeurY provides the user with a quiz-style interface to narrow down their preferences amongst dozens and dozens of drinks.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'liquery'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install liquery

## Usage

Running LiquerY will run an entirely self-contained CLI app. The user will begin with a quiz to identify their beverage preferences, and they will then have several options to explore the results of the quiz in more detail or to search the entire LiquerY database.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

Please also note that TheCocktailDb API(https://www.thecocktaildb.com) requires an application for an API key if you intend to release a version of this app on an appstore. At present, this gem continues to use the test key of "1", as I had no intention of releasing the CLI version of this program as an appstore app.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/aaj3f/LiquerY. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the LiquerY project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/aaj3f/LiquerY/blob/master/CODE_OF_CONDUCT.md).
