# GeonamesDump

GeonamesDump import geographic data from geonames project into your application, avoiding to use external service like google maps.
It's a "gem" version of the application [brownbeagle/geonames](https://github.com/brownbeagle/geonames).
Now you only need to include the dependency into your Gemfile and your project will include geonames.

You're free to use [geocoder](https://github.com/alexreisner/geocoder) or [geokit](https://github.com/imajes/geokit) or any other geocoding solution.

## Installation

Add this line to your application's Gemfile:

```
gem 'geonames_dump'
```

And then execute:

```
bundle install
```

Or install it yourself as:

```
gem install geonames_dump
```

## Usage

Create models and migration files

```
rails generate geonames_dump:install
```

Import data (takes a loonnnng time!), it will download data, import countries and many features (Countries, Cities having more than 15000 people, Admin1 (first administrative subdivision), Admin2 (second level administrative subdivision))

```
rake geonames_dump:install
```

If you need more fine grained control over the installation process you can run individual geoname rake tasks instead of the all-in-one install :

```
$ rake -T | grep geonames_dump

rake geonames_dump:import:all               # Import ALL geonames data.
rake geonames_dump:import:many              # Import most of geonames data.

rake geonames_dump:import:admin1            # Import admin1 codes
rake geonames_dump:import:admin2            # Import admin2 codes
rake geonames_dump:import:cities            # Import all cities, regardless of population.
rake geonames_dump:import:cities1000        # Import cities with population greater than 1000
rake geonames_dump:import:cities15000       # Import cities with population greater than 15000
rake geonames_dump:import:cities5000        # Import cities with population greater than 5000
rake geonames_dump:import:countries         # Import countries informations
rake geonames_dump:import:features          # Import feature data.
rake geonames_dump:import:alternate_names   # Import alternate names

rake geonames_dump:truncate:all             # Truncate all geonames data.
rake geonames_dump:truncate:countries       # Truncate countries informations
rake geonames_dump:truncate:admin1          # Truncate admin1 codes
rake geonames_dump:truncate:admin2          # Truncate admin2 codes
rake geonames_dump:truncate:cities          # Truncate cities informations
rake geonames_dump:truncate:features        # Truncate features informations
rake geonames_dump:truncate:alternate_names # Import alternate names
```

## Geonames data usage

The above commands will import geonames data in your Rails application, in other words, this will create models and fill database with place/city/country informations.
Now to find a city for example :

```
GeonamesFeature.search('paris')
```

If your request is ambiguous, like not searching Dublin in Ireland but Dublin in the USA, you may specify country :

```
GeonamesFeature.search('dublin, us')
```

Models available allows to specify the type of place you want to search for :

- GeonamesAdmin1, for first level of adminstrative subdivision
- GeonamesAdmin2, for second level of adminstrative subdivision
- GeonamesCity, for city names
- GeonamesFeature, for generic names including all the above
- GeonamesCountry, for country names

Searching for a city like dublin may be done using :

```
GeonamesCity.search('dublin')
```

You may use GeonamesDump search accessor :

```
GeonamesDump.search('dublin', type: :city)
GeonamesDump.search('dublin, us', type: :city)
GeonamesDump.search('paris', type: :feature)
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
