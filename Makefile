test:
	bundle exec rake

build:
	gem build parliament-ruby.gemspec

release: build test
	gem push parliament-ruby-*.gem
	rm parliament-ruby-*.gem




