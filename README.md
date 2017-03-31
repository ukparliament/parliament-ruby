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
  - [Methods](#methods)
    - [`#get`](#get)
    - [`#filter`](#filter)
    - [`#sort_by`](#sort_by)
    - [`#reverse_sort_by`](#reverse_sort_by)
  - [`Partliament::Utils`](#partliamentutils)
    - [Methods](#methods-1)
      - [`Parliament::Utils.sort_by`](#parliamentutilssort_by)
      - [`Parliament::Utils.reverse_sort_by`](#parliamentutilsreverse_sort_by)
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

> **Note:** Comprehensive class documentation can be found on [rubydocs][rubydocs].

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
parliament = Parliament::Request.new(base_url: 'http://test.com') #=>  #<Parliament::Request [...]>

# Target endpoint: 'http://test.com/parties/current'
parliament.parties.current

# Target endpoint: 'http://test.com/parties/123/people/current'
parliament.parties('123').people.current

# Target endpoint: 'http://test.com/people/123/letters/456'
parliament.people('123').letters('456')
```

### Setting headers

#### Setting headers 'globally'
Within the code you can set global headers using the following snippet.
```
Parliament::Request.headers = { 'Accept' => 'Test' }

# The headers should be set for all new objects
Parliament::Request.new.headers #=> { 'Accept' => 'Test' }

# You can still override the headers on an instance by instance basis
Parliament::Request.new(headers: { 'Accept' => 'Test2' }).headers #=> { 'Accept' => 'Test2' }
```
### Methods
[parliament-ruby][parliament-ruby] comes with the following common methods:

| Method                                 | Description |
|----------------------------------------|-------------|
| [`#get`](#get)                         | **Make a GET request** - Make a HTTP GET request to the endpoint we have built, and create Ruby objects. |
| [`#filter`](#filter)                   | **Filter the response** - After making a GET request, filter the objects returned by type attribute. |
| [`#sort_by`](#sort_by)                 | **Sort the response (ASC)** - After making a GET request, sort the result in ascending order. |
| [`#reverse_sort_by`](#reverse_sort_by) | **Sort the response (DESC)** - After making a GET request, sort the result in descending order. |

> **Note:** Comprehensive class documentation can be found on [rubydocs][rubydocs].

#### `#get`
Once you've built your endpoint (`parliament.people.current`), we use the `#get` method to tell us you're ready to get the data.

```ruby
# Target endpoint: 'http://test.com/people/123/letters/456'
response = parliament.people('123').letters('456').get #=> #<Parliament::Response [...]>

response.each do |node|
  # If your n-triple file contains a literal object it is stored into an instance variable accessible via the predicate
  # name. For example, with the following triple:
  # <http://id.ukpds.org/1234> <http://id.ukpds.org/schema/name> 'Matthew Rayner' .
  #
  # You would be able to access the `name` attribute like so:
  puts node.name #=> 'Matthew Rayner'
  
  # If your n-triple file contains a triple who's object is a URI, and that URI is defined within your file, a link will
  # be created, allowing you to 'connect' the two objects. For example, with the following triples:
  # <http://id.ukpds.org/1234> <http://id.ukpds.org/schema/name> 'Matthew Rayner' .
  # <http://id.ukpds.org/1234> <http://id.ukpds.org/schema/partyMembership> <http://id.ukpds.org/5678> .
  # <http://id.ukpds.org/5678> <http://id.ukpds.org/schema/startDate> "1992-04-09"^^<http://www.w3.org/2001/XMLSchema#date> .
  #
  # You would be able to access the start date attribute on the linked object like so:
  puts node.graph_id        #=> '12345'
  puts node.name            #=> 'Matthew Rayner'
  puts node.partyMembership #=> [#<Grom::Node @startDate=...>]
  
  puts node.partyMembership.first.startDate #=> "1992-04-09"
end
```

`#get` returns a `Parliament::Response` object which contains all of the nodes from our n-triple response.

#### `#filter`
If your n-triple file contains a number of different objects you can filter based on type attribute.

```ruby
# Target endpoint: 'http://test.com/people/members/current'
response = parliament.people.members.current.get #=> #<Parliament::Response [...]>

# Given the below set of triples, you will be able to filter on 'type' attribute.
# <http://id.ukpds.org/cea89432-e046-4013-a9ba-e93d0468d186> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://id.ukpds.org/schema/Person> .
# <http://id.ukpds.org/4ef6c7b7-a5c8-4dde-a5a5-29c9f80d8a27> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://id.ukpds.org/schema/Constituency> .
# <http://id.ukpds.org/80234c90-f86a-4942-b6ae-d1e57a0b378d> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://id.ukpds.org/schema/Party> .
# <http://id.ukpds.org/HouseOfCommons> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://id.ukpds.org/schema/House> .
#
# The filter method returns an array of filtered responses. Each response holding just items with the given type attribute.
filtered_responses = response.filter('http://id.ukpds.org/schema/Person', 'http://id.ukpds.org/schema/Party', 'http://id.ukpds.org/schema/Constituency')
filtered_responses #=> [<#Parliament::Response [...]>, <#Parliament::Response []>, <#Parliament::Response [...]>]
```

#### `#sort_by`
Once you have a `Parliament::Response` object, you can perform an ascending sort on the results by using the `#sort_by` method.

> **`#sort_by`** is an ascending order sort i.e. (a..z, 0..9)

```ruby
# Target endpoint: 'http://test.com/people/members/current'
response = parliament.people.members.current.get #=> #<Parliament::Response [...]>

# Given the below set of triples, you can sort ascending like so:
# <http://id.ukpds.org/1234> <http://id.ukpds.org/schema/startDate> "1997-01-01"^^<http://www.w3.org/2001/XMLSchema#date> .
# <http://id.ukpds.org/5678> <http://id.ukpds.org/schema/startDate> "1991-03-15"^^<http://www.w3.org/2001/XMLSchema#date> .
# <http://id.ukpds.org/9101> <http://id.ukpds.org/schema/startDate> "2011-09-04"^^<http://www.w3.org/2001/XMLSchema#date> .
# <http://id.ukpds.org/1121> <http://id.ukpds.org/schema/startDate> "1981-07-31"^^<http://www.w3.org/2001/XMLSchema#date> .
# <http://id.ukpds.org/3141> <http://id.ukpds.org/schema/endDate> "1997-07-31"^^<http://www.w3.org/2001/XMLSchema#date> .
#
# The sort_by method returns a sorted array of Grom::Nodes, sorted by one, or many, symbols passed to it.
sorted_response = response.sort_by(:startDate)

# Output each of the graph_id and startDate values
sorted_response.each { |node| puts "#{node.graph_id} - #{node.respond_to?(:startDate) ? node.startDate : 'undefined'}" }
# http://id.ukpds.org/3141 - undefined
# http://id.ukpds.org/1121 - 1981-07-31
# http://id.ukpds.org/5678 - 1991-03-15
# http://id.ukpds.org/1234 - 1997-01-01
# http://id.ukpds.org/9101 - 2011-09-04
```

> **NOTE:** `#sort_by` places all `nil` responses at the start of the sort. For a more custom sort, take a look at `Parliament::Utils.sort_by`.

#### `#reverse_sort_by`
`#reverse_sort_by` simple implements `#sort_by` and calls `#reverse!` on the resulting array. The above example would become:

```ruby
# http://id.ukpds.org/9101 - 2011-09-04
# http://id.ukpds.org/1234 - 1997-01-01
# http://id.ukpds.org/5678 - 1991-03-15
# http://id.ukpds.org/1121 - 1981-07-31
# http://id.ukpds.org/3141 - undefined
```

### `Partliament::Utils`
Included with [parliament-ruby][parliament-ruby] is `Parliament::Utils`. This module includes helper methods commonly used throughout parliament.uk.

#### Methods

| Method                                                | Description |
|-------------------------------------------------------|-------------|
| [`#sort_by`](#parliamentutilssort_by)                 | **Sort an enumerable thing (ASC)** - An implementation of ruby's `#sort_by` method that allows nil sorts. |
| [`#reverse_sort_by`](#parliamentutilsreverse_sort_by) | **Sort an enumerable thing (DESC)** - Reverse the result of `Parliament::Utils.reverse_sort_by` |


##### `Parliament::Utils.sort_by`
One of the common use cases we have is sorting objects by a date (e.g. seat incumbency end date) where an object without an end date is considered 'current' and should be sorted to the top (or bottom) of a list.

Because we working with graph databases, a node without an endDate simply has no method when converted to an object with [GROM][grom].

The `Parliament::Utils.sort_by` method takes a hash of options, detailed below:

```ruby
response = parliament.people('123').get.filter('http://id.ukpds.org/schema/Person')

objects = response.first.incumbencies

options = {
  list: objects,          # An enumerable of objects (most commonly an Array)
  parameters: [:endDate], # An array of actions which we will sort by
  prepend_rejected: false # {optional  default=true} Should any objects that are 'rejected' be prepended to the sorted list, or appended. i.e. where to put objects that don't respond to parameters provided
}

sorted_list = Parliament::Util.sort_by(options)

sorted_list.each { |incumbency| puts incumbency.respond_to?(:endDate) ? incumbency.endDate : 'Current' }
# http://id.ukpds.org/1121 - 1981-07-31
# http://id.ukpds.org/5678 - 1991-03-15
# http://id.ukpds.org/1234 - 1997-01-01
# http://id.ukpds.org/9101 - 2011-09-04
# http://id.ukpds.org/3141 - Current
```

##### `Parliament::Utils.reverse_sort_by`
This method, under the hood, calls `Parliament::Utils.sort_by` and runs `#reverse!` on the result.

Following the above example, and changing:
```ruby
sorted_list = Parliament::Util.sort_by(options)
```

to:
```ruby
sorted_list = Parliament::Util.reverse_sort_by(options)
```

should result in:
```ruby
    # http://id.ukpds.org/3141 - Current
    # http://id.ukpds.org/9101 - 2011-09-04
    # http://id.ukpds.org/1234 - 1997-01-01
    # http://id.ukpds.org/5678 - 1991-03-15
    # http://id.ukpds.org/1121 - 1981-07-31
```


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
[grom]:            https://github.com/ukparliament/grom
[rubydocs]:        http://www.rubydoc.info/github/ukparliament/parliament-ruby/master/file/README.md

[info-gem]:  https://rubygems.org/gems/parliament-ruby
[shield-gem]: https://img.shields.io/gem/v/parliament-ruby.svg

[info-travis]:   https://travis-ci.org/ukparliament/parliament-ruby
[shield-travis]: https://img.shields.io/travis/ukparliament/parliament-ruby.svg

[info-coveralls]:   https://coveralls.io/github/ukparliament/parliament-ruby
[shield-coveralls]: https://img.shields.io/coveralls/ukparliament/parliament-ruby.svg

[info-license]:   http://www.parliament.uk/site-information/copyright/open-parliament-licence/
[shield-license]: https://img.shields.io/badge/license-Open%20Parliament%20Licence-blue.svg
