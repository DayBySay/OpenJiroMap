all: install

install:
	bundle install --path=vendor/bundle
	bundle exec pod install
