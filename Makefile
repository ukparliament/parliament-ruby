gemset:
	rvm gemset create parliament-ruby
	rvm --force gemset empty parliament-ruby
	rvm gemset use parliament-ruby

test: gemset
	bundle install
	bundle exec rake

build:
	rm -f parliament-ruby-*.gem
	gem build parliament-ruby.gemspec

release: build test
	gem push parliament-ruby-*.gem
	rm parliament-ruby-*.gem
