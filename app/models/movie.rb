class Movie < ActiveRecord::Base
  def self.all_ratings
    %w(G PG PG-13 NC-17 R NR n/a)
  end
  
 class Movie::InvalidKeyError < StandardError ; end
  
  Tmdb::Api.key('f4702b08c0ac6ea5b51425788bb26562')
  
  def self.find_in_tmdb(string)
    begin
      movie_rating = ''
      allMovies = [] #hash
      if !Tmdb::Movie.find(string).nil? || !Tmdb::Movie.find(string).empty?
        Tmdb::Movie.find(string).each do |movie|
          Tmdb::Movie.releases(movie.id)["countries"].each do |findRating|
            if findRating["iso_3166_1"] == "US"
              movie_rating = findRating["certification"]
            end
          end
          movieData = {:tmdb_id => movie.id, :title => movie.title, :release_date => movie.release_date, :rating => movie_rating}
          allMovies.push(movieData)
        end
      end
      return allMovies
    rescue Tmdb::InvalidApiKeyError
        raise Movie::InvalidKeyError, 'Invalid API key'
    end
  end
  
  def self.create_from_tmdb(tmdb_id)
    movie = Tmdb::Movie.detail(tmdb_id)
    movie_rating = 'n/a'
    Tmdb::Movie.releases(tmdb_id)["countries"].each do |findRating|
      if findRating["iso_3166_1"] == "US"
        if !findRating["certification"].empty?
          movie_rating = findRating["certification"]
        end
      end
    end
    Movie.create(title: movie["title"], rating: movie_rating, release_date: movie["release_date"])
  end

end