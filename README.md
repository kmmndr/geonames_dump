# GeonamesDump

GeonamesDump import geographic data from geonames project into your application, avoiding to use external service like google maps.
It's a "gem" version of the application [brownbeagle/geonames](https://github.com/brownbeagle/geonames).
Now you only needs to include the dependency into your Gemfile and your project will include geonames.

## Installation

Add this line to your application's Gemfile:

    gem 'geonames_dump'

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install geonames_dump

## Usage

Create models and migration files

    $ rails generate geonames_dump:install

Import data (takes a loonnnng time!)

    $ rake geonames_dump:install

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
