# GeonamesDump

GeonamesDump import geographic data from geonames project into your application, avoiding to use external service like google maps.
It's a "gem" version of the application [brownbeagle/geonames](https://github.com/brownbeagle/geonames).
Now you only need to include the dependency into your Gemfile and your project will include geonames.

You're free to use [geocoder](https://github.com/alexreisner/geocoder) or [geokit](https://github.com/imajes/geokit) or any other geocoding solution.

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

Import data (takes a loonnnng time!), it will download data, import countries and many features (Countries, Cities, Admin1 (first administrative subdivision), Admin2 (second level administrative subdivision))

    $ rake geonames_dump:install

If you need more fine grained control over the installation process you can run individual geoname rake tasks instead of the all-in-one install :

    rake -T |grep geonames_dump

    rake geonames_dump:import:admin1       # Import admin1 codes
    rake geonames_dump:import:admin2       # Import admin2 codes
    rake geonames_dump:import:all          # Import all geonames data.
    rake geonames_dump:import:cities       # Import all cities, regardless of population.
    rake geonames_dump:import:cities1000   # Import cities with population greater than 1000
    rake geonames_dump:import:cities15000  # Import cities with population greater than 15000
    rake geonames_dump:import:cities5000   # Import cities with population greater than 5000
    rake geonames_dump:import:countries    # Import country information
    rake geonames_dump:import:features     # Import feature data.
    rake geonames_dump:install             # Generate and install migrations, then download and import all data (except geonames:import:features)
    rake geonames_dump:truncate:admin1     # Truncate admin1 codes
    rake geonames_dump:truncate:admin2     # Truncate admin2 codes
    rake geonames_dump:truncate:all        # Truncate all geonames data.
    rake geonames_dump:truncate:cities     # Truncate cities informations
    rake geonames_dump:truncate:countries  # Truncate countries informations
    rake geonames_dump:truncate:features   # Truncate features informations


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
