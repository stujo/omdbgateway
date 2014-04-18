# omdbgateway

[![Gem Version](https://badge.fury.io/rb/omdbgateway.svg)](http://badge.fury.io/rb/omdbgateway)

__Note__ is a faraday rewrite of [Casey Scarborough's omdbapi](https://github.com/caseyscarborough/omdbapi)

Not that there's anything wrong with what he did, I just wanted to try faraday and we're using OMDB
in our class


#Installation

##Install the gem
```

gem install omdbgateway

```

##Use it in your gemfile
```
gem "omdbgateway"

```


#Usage

##Title Search

Returns a single item (chosen by OMDB) as a Hash

```

require 'omdbgateway'

OMDBGateway.gateway.title_search('Star Wars')
 => #<OMDBGateway::ResponseWrapper:0x00000101ca5218 @http_status=200, @body={"Title"=>"Star Wars", "Year"=>"1983", "Rated"=>"N/A", "Released"=>"01 May 1983", "Runtime"=>"N/A", "Genre"=>"Action, Adventure, Sci-Fi", "Director"=>"N/A", "Writer"=>"N/A", "Actors"=>"Harrison Ford, Alec Guinness, Mark Hamill, James Earl Jones", "Plot"=>"N/A", "Language"=>"English", "Country"=>"USA", "Awards"=>"N/A", "Poster"=>"N/A", "Metascore"=>"N/A", "imdbRating"=>"7.3", "imdbVotes"=>"292", "imdbID"=>"tt0251413", "Type"=>"game", "Response"=>"True"}, app_failedfalse

OMDBGateway.gateway.title_search('Star Wars').body
 => {"Title"=>"Star Wars", "Year"=>"1983", "Rated"=>"N/A", "Released"=>"01 May 1983", "Runtime"=>"N/A", "Genre"=>"Action, Adventure, Sci-Fi", "Director"=>"N/A", "Writer"=>"N/A", "Actors"=>"Harrison Ford, Alec Guinness, Mark Hamill, James Earl Jones", "Plot"=>"N/A", "Language"=>"English", "Country"=>"USA", "Awards"=>"N/A", "Poster"=>"N/A", "Metascore"=>"N/A", "imdbRating"=>"7.3", "imdbVotes"=>"292", "imdbID"=>"tt0251413", "Type"=>"game", "Response"=>"True"}

OMDBGateway.gateway.title_search('Star Wars').body.class
 => Hash

```


##Free Text Search

Returns an array of items (chosen by OMDB) as Hashes

each with Title, Year, imdbID and Type fields

```

OMDBGateway.gateway.free_search('Jedi')
 => #<OMDBGateway::ResponseWrapper:0x00000102167440 @http_status=200, @body=[{"Title"=>"Star Wars: Episode VI - Return of the Jedi", "Year"=>"1983", "imdbID"=>"tt0086190", "Type"=>"movie"}, {"Title"=>"Star Wars: Jedi Knight II - Jedi Outcast", "Year"=>"2002", "imdbID"=>"tt0297410", "Type"=>"game"}, {"Title"=>"Star Wars: Jedi Knight II - Jedi Outcast", "Year"=>"2002", "imdbID"=>"tt0297410", "Type"=>"game"}, {"Title"=>"Star Wars: Jedi Knight II - Jedi Outcast", "Year"=>"2002", "imdbID"=>"tt0297410", "Type"=>"game"}, {"Title"=>"Star Wars: Jedi Knight - Jedi Academy", "Year"=>"2003", "imdbID"=>"tt0362179", "Type"=>"game"}, {"Title"=>"Star Wars: Jedi Knight - Dark Forces II", "Year"=>"1997", "imdbID"=>"tt0160910", "Type"=>"game"}, {"Title"=>"From 'Star Wars' to 'Jedi': The Making of a Saga", "Year"=>"1983", "imdbID"=>"tt0295270", "Type"=>"movie"}, {"Title"=>"The Wrong Jedi", "Year"=>"2013", "imdbID"=>"tt2628854", "Type"=>"episode"}, {"Title"=>"Bombad Jedi", "Year"=>"2008", "imdbID"=>"tt1322836", "Type"=>"episode"}, {"Title"=>"Jedi Junkies", "Year"=>"2010", "imdbID"=>"tt1662514", "Type"=>"movie"}], app_failedfalse


OMDBGateway.gateway.free_search('Jedi').body
 => [
 {"Title"=>"Star Wars: Episode VI - Return of the Jedi",
  "Year"=>"1983",
  "imdbID"=>"tt0086190",
  "Type"=>"movie"},
 {"Title"=>"Star Wars: Jedi Knight II - Jedi Outcast",
  "Year"=>"2002",
  "imdbID"=>"tt0297410",
  "Type"=>"game"},
 {"Title"=>"Star Wars: Jedi Knight II - Jedi Outcast",
  "Year"=>"2002",
  "imdbID"=>"tt0297410",
  "Type"=>"game"},
 {"Title"=>"Star Wars: Jedi Knight II - Jedi Outcast",
  "Year"=>"2002",
  "imdbID"=>"tt0297410",
  "Type"=>"game"},
 {"Title"=>"Star Wars: Jedi Knight - Jedi Academy",
  "Year"=>"2003",
  "imdbID"=>"tt0362179",
  "Type"=>"game"},
 {"Title"=>"Star Wars: Jedi Knight - Dark Forces II",
  "Year"=>"1997",
  "imdbID"=>"tt0160910",
  "Type"=>"game"},
 {"Title"=>"From 'Star Wars' to 'Jedi': The Making of a Saga",
  "Year"=>"1983",
  "imdbID"=>"tt0295270",
  "Type"=>"movie"},
 {"Title"=>"The Wrong Jedi",
  "Year"=>"2013",
  "imdbID"=>"tt2628854",
  "Type"=>"episode"},
 {"Title"=>"Bombad Jedi",
  "Year"=>"2008",
  "imdbID"=>"tt1322836",
  "Type"=>"episode"},
 {"Title"=>"Jedi Junkies",
  "Year"=>"2010",
  "imdbID"=>"tt1662514",
  "Type"=>"movie"}
]

```

## Find By Id

Returns a single item as a Hash with all available fields


```

OMDBGateway.gateway.find_by_id('tt0297410').body
=>{
 "Title"=>"Star Wars: Jedi Knight II - Jedi Outcast",
 "Year"=>"2002",
 "Rated"=>"N/A",
 "Released"=>"29 Mar 2002",
 "Runtime"=>"N/A",
 "Genre"=>"Action, Adventure, Fantasy",
 "Director"=>"N/A",
 "Writer"=>"Kenn Hoekstra (manual), Michael Stemmle (script)",
 "Actors"=>
  "Jeff Bennett, Mark Klastorin, Billy Dee Williams, Vanessa Marshall",
 "Plot"=>
  "You guide mercenary Kyle Katarn, who must stop the evil plot of a renegade Jedi by relearning his skills as a Jedi Knight.",
 "Language"=>"English",
 "Country"=>"USA",
 "Awards"=>"N/A",
 "Poster"=>"N/A",
 "Metascore"=>"N/A",
 "imdbRating"=>"8.3",
 "imdbVotes"=>"1,000",
 "imdbID"=>"tt0297410",
 "Type"=>"game",
 "Response"=>"True"
 }
```



## Error States

### success?

```
 # An failed request, returns false for success?

OMDBGateway.gateway.find_by_id('tt0297CCC').success?
 => false

 # An successful request, returns true for success?

OMDBGateway.gateway.find_by_id('tt1322836').success?
 => true

```


### app_success?

If you need to know if the app (The omdbapi.com service) was successfully called
and then failed or succeeded to successfully process the input then use app_success?

```
 # An failed request, returns false for app_success?

OMDBGateway.gateway.find_by_id('tt0297CCC').app_success?
 => false

 # An successful request, returns true for app_success?

OMDBGateway.gateway.find_by_id('tt1322836').app_success?
 => true

```

### http_success?

If you need to know if the transport failed, use http_success?

```
 #Transport succeeded but the app returned a failure

OMDBGateway.gateway.find_by_id('tt0297CCC').http_success?
 => true

```





## Result Pruning

Sometimes you don't want the whole result body, you just want a single tag or index

```
 #All the data

OMDBGateway.gateway.find_by_id('tt1322836').body
 => {"Title"=>"Bombad Jedi", "Year"=>"2008", "Rated"=>"N/A", "Released"=>"N/A", "Runtime"=>"22 min", "Genre"=>"Animation, Action, Adventure, Drama, Fantasy, Sci-Fi", "Director"=>"Dave Filoni", "Writer"=>"George Lucas, Steven Melching", "Actors"=>"Anthony Daniels, Ahmed Best, Catherine Taber, Matthew Wood", "Plot"=>"Padmé Amidala travels to Rodia to meet with old family friend Onaconda Farr about the lack of food rations...", "Language"=>"N/A", "Country"=>"N/A", "Awards"=>"N/A", "Poster"=>"http://ia.media-imdb.com/images/M/MV5BMTM0NjQ2Mjk0OV5BMl5BanBnXkFtZTcwODQ3Njc3Mg@@._V1_SX300.jpg", "Metascore"=>"N/A", "imdbRating"=>"6.8", "imdbVotes"=>"265", "imdbID"=>"tt1322836", "Type"=>"episode", "Response"=>"True"}

```

## prune_hash(tag)

```
 #Just the Poster value

OMDBGateway.gateway.find_by_id('tt1322836').prune_hash('Poster').body
 => "http://ia.media-imdb.com/images/M/MV5BMTM0NjQ2Mjk0OV5BMl5BanBnXkFtZTcwODQ3Njc3Mg@@._V1_SX300.jpg"


```

## prune_array(index)

```
 #Just the 2nd result

OMDBGateway.gateway.free_search('Jedi').prune_array(1).body
 => {"Title"=>"Star Wars: Jedi Knight II - Jedi Outcast", "Year"=>"2002", "imdbID"=>"tt0297410", "Type"=>"game"}

```

## prune_xxx chaining

If needed prune methods can be chained

```

OMDBGateway.gateway.free_search('Jedi').prune_array(1).prune_hash('Year').body
 => "2002"

```


## prune_xxx default

If needed a default value can be specified, used if the key does not exist

```

OMDBGateway.gateway.free_search('Jedi').prune_array(1).prune_hash('Axiom', 123).body
 => 123

```