*turn and face the strange*
# Chchchanges

### chchchanges makes it convenient to create and maintain a proper CHANGELOG.

With chchchanges, users can create CHANGELOG entries from the command line. Each
entry is saved as in individual .json file which prevents CHANGELOG merge conflicts.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'chchchanges'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install chchchanges

## Usage

When starting a changelog from scratch, simply use the command `$ chchchanges -e` and
follow the prompts to create a changelog entry. Than command will create a .json file with the changelog entry data. The file name will be unique, thereby ensuring that future changelog entries will not result in git merge conflicts.  Every time you generate a changelog entry with the `chchchanges -e` command, a new unique file is created.

### *But now I have a bunch of .json files with changelog data, and I want to have a nice CHANGELOG.md document*

To generate a CHANGELOG.md document from your .json changelog entry files, run the command `$ chchchanges -g`

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/chchchanges. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
