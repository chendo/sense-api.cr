# Hello Sense API

An API for accessing the data available from a Hello Sense, which is a nice sleep tracking device which can also track temperature, humidity, air quality, noise and brightness.

## Installation

Add this to your application's shard.yml:

```yaml
dependencies:
  sense-api:
    github: chendo/sense-api.cr
    version: ~> 0.1
```
And install dependencies:

```
crystal deps
```

## Usage

```crystal
require "sense-api"

# Create an instance

client = Sense::API.new(email: "<email>", password: "password")
# or
client = Sense::API.new(access_token: "<access_token>")

pp client.current_sensors
pp client.temperature_by_week
pp client.timeline(Date.new(2016, 01, 01))
```

## Contributing

1. Fork it ( https://github.com/[your-github-name]/sense-api/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [chendo](https://github.com/chendo) Jack Chen (chendo) - creator, maintainer
