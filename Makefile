.PHONY: checkout_to_release

# Github variables
GITHUB_API=https://api.github.com
ORG=ukparliament
REPO=parliament-ruby
LATEST_REL=$(GITHUB_API)/repos/$(ORG)/$(REPO)/releases
REL_TAG=$(shell curl -s $(LATEST_REL) | jq -r '.[0].tag_name')

checkout_to_release:
	git checkout -b release $(REL_TAG)

checkout_to_pull_request:
	git fetch origin refs/pull/$(PULL_REQUEST_NUMBER)/merge
	git checkout $(PULL_REQUEST_MERGE_SHA1)

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
