# Comma Splice

This gem tackles one very specific problem: when CSVs have commas in the values and the values haven't been quoted. This determines which commas separate fields and which commas are part of a value, and corrects the file.

For example, given the following CSV

```
timestamp,artist,title,albumtitle,label
01-27-2019 @ 12:34:00,Lester Sterling, Lynn Taitt & The Jets,Check Point Charlie,Merritone Rock Steady 3: Bang Bang Rock Steady 1966-1968,Dub Store,
01-27-2019 @ 12:31:00,Lester Sterling,Lester Sterling Special,Merritone Rock Steady 2: This Music Got Soul 1966-1967,Dub Store,

```

which parses incorrectly as:

| timestamp             | artist          | title       | albumtitle      | label                                                      |
|-----------------------|-----------------|-------------|-----------------|------------------------------------------------------------|
| 01-27-2019 @ 12:34:00 | Lester Sterling | Lynn Taitt & The Jets   | Check Point Charlie                                    | Merritone Rock Steady 3: Bang Bang Rock Steady 1966-1968
| 01-27-2019 @ 12:31:00 | Lester Sterling | Lester Sterling Special | Merritone Rock Steady 2: This Music Got Soul 1966-1967 | Dub Store   |


Running this through `comma_splice fix /path/to/file` will return this corrected content:

```
timestamp,artist,title,albumtitle,label
01-27-2019 @ 12:34:00,"Lester Sterling, Lynn Taitt & The Jets",Check Point Charlie,Merritone Rock Steady 3: Bang Bang Rock Steady 1966-1968,Dub Store,
01-27-2019 @ 12:31:00,Lester Sterling,Lester Sterling Special,Merritone Rock Steady 2: This Music Got Soul 1966-1967,Dub Store,
```

| timestamp             | artist          | title       | albumtitle      | label                                                      |
|-----------------------|-----------------|-------------|-----------------|------------------------------------------------------------|
| 01-27-2019 @ 12:34:00 | Lester Sterling, Lynn Taitt & The Jets   | Check Point Charlie | Merritone Rock Steady 3: Bang Bang Rock Steady 1966-1968 | Dub Store |
| 01-27-2019 @ 12:31:00 | Lester Sterling | Lester Sterling Special | Merritone Rock Steady 2: This Music Got Soul 1966-1967 | Dub Store   |


If it can't determine where the comma should go, it prompts you for the possible options


given the following CSV:

```
playid,playtype,genre,timestamp,artist,title,albumtitle,label,prepost,programtype,iswebcast,isrequest
16851097,,,12-09-2017 @ 09:57:00,10,000 Maniacs and Michael Stipe,To Sir with Love,Campfire Songs,Rhino,post,live,y,
16851096,,,12-09-2017 @ 09:44:00,Fran Jeffries,Mine Eyes,Fran Can Really Hang You Up the Most,Warwick,post,live,y,
```

It prompts:

```
Which one of these is correct?

(1)  artist    : 10
     title     : 000 Maniacs and Michael Stipe
     albumtitle: To Sir with Love
     label     : "Campfire Songs,Rhino"

(2)  artist    : 10
     title     : 000 Maniacs and Michael Stipe
     albumtitle: "To Sir with Love,Campfire Songs"
     label     : Rhino

(3)  artist    : 10
     title     : "000 Maniacs and Michael Stipe,To Sir with Love"
     albumtitle: Campfire Songs
     label     : Rhino

(4)  artist    : "10,000 Maniacs and Michael Stipe"
     title     : To Sir with Love
     albumtitle: Campfire Songs
     label     : Rhino
```

Select an option (4), and it returns:

```
playid,playtype,genre,timestamp,artist,title,albumtitle,label,prepost,programtype,iswebcast,isrequest
16851097,,,12-09-2017 @ 09:57:00,"10,000 Maniacs and Michael Stipe",To Sir with Love,Campfire Songs,Rhino,post,live,y,
16851096,,,12-09-2017 @ 09:44:00,Fran Jeffries,Mine Eyes,Fran Can Really Hang You Up the Most,Warwick,post,live,y,
```

## Usage

You can use this in a ruby program by using installing the `comma_splice` gem, or you can install it on your system and use the `comma_splice` command line utility.


##### Return the number of bad lines in a file

```ruby
  CommaSplice::FileCorrector.new(file_path).bad_lines.size
```
```
  comma_splice bad_line_count /path/to/file.csv
```

##### Display the fixed contents
```ruby
  CommaSplice::FileCorrector.new(file_path).corrected
```
```bash
  comma_splice correct /path/to/file.csv
```

##### Process a file and save the fixed version
```ruby
  CommaSplice::FileCorrector.new(file_path).save(save_path)
```
```bash
  comma_splice fix /path/to/file.csv /path/to/save
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'comma_splice'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install comma_splice

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jkeen/comma_splice.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
