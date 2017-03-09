# Parliament Data API Wrapper (Ruby)
[parliament-ruby][parliament-ruby] is a gem created by the [Parliamentary Digital Service][pds] to allow easy communication with the internal parliament data api.

[![Gem][shield-gem]][info-gem] [![Build Status][shield-travis]][info-travis] [![Test Coverage][shield-coveralls]][info-coveralls] [![License][shield-license]][info-license]

> **NOTE:** This gem is in active development and is likely to change at short notice. It is not recommended that you use this in any production environment.

### Contents
<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->


- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
  - [Setting up a connection](#setting-up-a-connection)
    - [Setting a base URL 'globally'](#setting-a-base-url-globally)
  - [Building an 'endpoint'](#building-an-endpoint)
    - [What's #get?](#whats-get)
- [Getting Started with Development](#getting-started-with-development)
  - [Running the tests](#running-the-tests)
- [Contributing](#contributing)
- [License](#license)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


## Requirements
[parliament-ruby][parliament-ruby] requires the following:
* [Ruby][ruby] - [click here][ruby-version] for the exact version
* [Bundler][bundler]


## Installation
This gem is currently not available on RubyGems. To use it in an application, install it directly from GitHub via your Gemfile
```bash
gem 'parliament', git: 'https://github.com/ukparliament/parliament-ruby.git', branch: 'master'
```


## Usage
This gem's main function is fetching an n-triple file from a remote server and converting it into linked ruby objects.

### Setting up a connection
In order to connect to a remote server, we first need to set a base_url value, from which we will build an 'endpoint'. The base_url should be the beginning of a url without the trailing slash. For example `http://example.com` instead of `http://example.com/`.
```ruby
parliament = Parliament::Request.new(base_url: 'http://test.com')
```

#### Setting a base URL 'globally'
Within code you can set a global base URL using the following snippet.
```ruby
Parliament::Request.base_url = 'http://test.com'

# The base_url should be set for all new objects
Parliament::Request.new.base_url #=> 'http://test.com'

# You can still override the base_url on an instance by instance basis
Parliament::Request.new(base_url: 'http://example.com').base_url #=> 'http://example.com'
```

Alternatively, you can set the environment variable `PARLIAMENT_BASE_URL` on your machine and we will automatically use that.
```ruby
ENV['PARLIAMENT_BASE_URL'] #=> 'http://example.com'

Parliament::Request.base_url #=> nil

Parliament::Request.new.base_url #=> 'http://example.com'
```


### Building an 'endpoint'
Now that we have a `base_url` set, we will want to build an 'endpoint' such as: `http://test.com/parties/current`.

An endpoint is effectively just a full URL to an n-triple file on a remote server.

Building an endpoint is simple, once you have a Parliament::Request object, you do something like this:
```ruby
parliament = Parliament::Request.new(base_url: 'http://test.com') #=>  #<Parliament::Request>

# target endpoint: 'http://test.com/parties/current'
parliament.parties.current.get

# target endpoint: 'http://test.com/parties/123/people/current'
parliament.parties('123').people.current.get

# target endpoint: 'http://test.com/people/123/letters/456'
parliament.people('123').letters('456').get
```

#### What's #get?
Once you've built your endpoint (`parliament.people.current`), we use the `#get` method to tell us you're finished building and ready to get the data. 


## Getting Started with Development
To clone the repository and set up the dependencies, run the following:
```bash
git clone https://github.com/ukparliament/parliament-ruby.git
cd parliament-ruby
bundle install
```

### Running the tests
We use [RSpec][rspec] as our testing framework and tests can be run using:
```bash
bundle exec rake
```


## Contributing
If you wish to submit a bug fix or feature, you can create a pull request and it will be merged pending a code review.

1. Fork the repository
1. Create your feature branch (`git checkout -b my-new-feature`)
1. Commit your changes (`git commit -am 'Add some feature'`)
1. Push to the branch (`git push origin my-new-feature`)
1. Ensure your changes are tested using [Rspec][rspec]
1. Create a new Pull Request


## License
[parliament-ruby][parliament-ruby] is licensed under the [Open Parliament Licence][info-license].

[ruby]:            https://www.ruby-lang.org/en/
[bundler]:         http://bundler.io
[rspec]:           http://rspec.info
[parliament-ruby]: https://github.com/ukparliament/parliament-ruby
[pds]:             https://www.parliament.uk/mps-lords-and-offices/offices/bicameral/parliamentary-digital-service/
[ruby-version]:    https://github.com/ukparliament/parliament-ruby/blob/master/.ruby-version

[info-gem]:  https://rubygems.org/gems/parliament-ruby
[shield-gem]: https://img.shields.io/gem/v/formatador.svg

[info-travis]:   https://travis-ci.org/ukparliament/parliament-ruby
[shield-travis]: https://img.shields.io/travis/ukparliament/parliament-ruby.svg

[info-coveralls]:   https://coveralls.io/github/ukparliament/parliament-ruby
[shield-coveralls]: https://img.shields.io/coveralls/ukparliament/parliament-ruby.svg

[info-license]:   http://www.parliament.uk/site-information/copyright/open-parliament-licence/
[shield-license]: https://img.shields.io/badge/license-Open%20Parliament%20Licence-blue.svg
