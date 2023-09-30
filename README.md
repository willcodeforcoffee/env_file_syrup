# EnvFileSyrup

This is a Ruby gem to programmatically parse, manipulate, and combine `.env` style environment files.

This gem is *only* for manipulating and creating files, **it does not load or change the environment** the way a tool like [dotenv](https://github.com/bkeepers/dotenv) would.

## Usage

`EnvFileSyrup::EnvFile` is the main file class. It recognizes three line types within an `.env` file:

- Key/Value(/Comment) lines: lines starting with `KEY=value` or an optional comment `KEY=value # comment`
- Comment lines: lines starting `#` characters for comments
- Blank lines: empty space lines

You can create a new `EnvFile` using `EnvFile.new` or by `EnvFile.parse`.

### Parsing an EnvFile

To reduce dependencies and keep things simple the `#parse` method takes only a string. So to read and parse a file you'd do something similar to the following:

```ruby
content = File.read('.env')
env_file = EnvFileSyrup::EnvFile.parse(content)
```

### Merging two EnvFiles

EnvFileSyrup merges files by overwriting the value in the original file with the value from the new file using the following rules:

- Overwrite values in place to keep groups together
- Maintain blank lines and comments where possible

Like Ruby's [Hash#merge](https://apidock.com/ruby/Hash/merge) the `EnvFile#merge` method returns a new `EnvFile` instance. So merging `other_env_file` into `env_file` creates a new `env_file` as follows:

```ruby
other_env_file = EnvFileSyrup::EnvFile.parse(content)

env_file = env_file.merge(other_env_file)
```

#### Merge Example

Given `env_file` from the above example as:

```env
# Env File 1
KEY1=first1 # no change comment
KEY2=first2 # Comment at end of line

# A section split and content
KEY3=first3 # Comment on line 3
```

and `other_env_file` as

```env
KEY1=second1
KEY2=second2 # New comment too

# Env File 2
KEY4=second4
```

the expected result would be:

```env
# Env File 1
KEY1=second1 # no change comment
KEY2=second2 # New comment too

# A section split and content
KEY3=first3 # Comment on line 3

# Env File 2
KEY4=second4
```

### Writing the new EnvFile

The `#to_s` method is overloaded to return a string formatted so it can be written directly to disk.

```ruby
File.open('.env') do |f|
    f.write(env_file.to_s)
end
```

### Convert to a hash

The `#to_h` method is overloaded to return a hash of all key/value rows in the file. Comments and blank lines are not included in the hash.

```ruby
h = env_file.to_h
puts h['KEY1'] # value1
```

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add env_file_syrup

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install env_file_syrup

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/willcodeforcoffee/env_file_syrup.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
