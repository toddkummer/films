# Scenes of San Francisco

Got a favorite movie filmed in San Francisco? There are lots of great choices.

![Vertigo](https://image.tmdb.org/t/p/w154/15uOEfqBNTVtDUT7hGBVCka0rZz.jpg) ![The Rock](https://image.tmdb.org/t/p/w154/j5mxLNWjUlXUUk8weFBtnF4afIR.jpg) ![Mrs. Doubtfire](https://image.tmdb.org/t/p/w154/shHrSmXS5140o6sQzgzXxn3KqSm.jpg)

This for fun project uses [a cool data set from Data SF](https://data.sfgov.org/Culture-and-Recreation/Film-Locations-in-San-Francisco/yitu-d5am/about_data) as well as movie posters from [The Movie DB (TMDB)](https://www.themoviedb.org/?language=en-US) all in service of providing a sample implementation for [the Filterameter gem](https://github.com/RockSolt/filterameter).

## Filterameter

Filterameter provides declarative filters for query classes or Rails controllers to reduce boilerplate code and increase readability. How many times have you seen (or written) this controller action?

```ruby
def index
  @films = Films.all
  @films = @films.where(name: params[:name]) if params[:name]
  @films = @films.joins(:film_locations).merge(FilmLocations.where(location_id: params[:location_id])) if params[:location_id]
  @films = @films.directed_by(params[:director_id]) if params[:director_id]
  @films = @films.written_by(params[:writer_id]) if params[:writer_id]
  @films = @films.acted_by(params[:actor_id]) if params[:actor_id]
end
```

It's redundant code and a bit of a pain to write and maintain. Not to mention what RuboCop is going to say about it. (If your head just went there, I checked: [the 1987 film RoboCop](https://www.themoviedb.org/movie/5548-robocop?language=en-US) was set in Detroit but filmed primarily in Dallas.)

Wouldn't it be nice if you could just declare the filters that the controller accepts?

```ruby
  filter :name, partial: true
  filter :location_id, association: :film_locations
  filter :director_id, name: :directed_by
  filter :writer_id, name: :written_by
  filter :actor_id, name: :acted_by
```

That's the value proposition of Filterameter. I hope you'll check it out.

### Links

- GitHub: https://github.com/RockSolt/filterameter
- Ruby Gems: https://rubygems.org/gems/filterameter

## Running the Application

The film data is checked into the repo as a CSV file and can be loaded with a rake task:

```bash
bundle exec rake film_data:load
```

Once the data has been loaded, run the server with `bin/dev`.

### What about the movie posters?!?

This product uses the TMDB API but is not endorsed or certified by TMDB.

In order to be able to look up the movie posters, you need to [create an API key with TMDB](https://developer.themoviedb.org/docs/getting-started). Then provide the key via environment variable `TMDB_API_READ_ACCESS_TOKEN`.

## Credits

Film data from [DATA SF](https://data.sfgov.org/Culture-and-Recreation/Film-Locations-in-San-Francisco/yitu-d5am/about_data).

Movie posters from The Movie DB.

<img src="https://www.themoviedb.org/assets/2/v4/logos/v2/blue_square_1-5bdc75aaebeb75dc7ae79426ddd9be3b2be1e342510f8202baf6bffa71d7f5c4.svg" style="width: 200px;"/>




