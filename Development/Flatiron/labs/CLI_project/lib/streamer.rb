class Streamer
  extend SeekAndDestroyable
  attr_accessor :name, :movies
  @@all=[]

  def initialize(name)
    @name = name
    @movies = []
  end

  def save
    @@all << self
  end

  def self.all
    @@all
  end

  def create_library
    library = Scraper.streamer_scraper(name)
    library.each do |movie|
      if Movie.find_by_name(movie[:name])
        old_movie = Movie.find_by_name(movie[:name])
        if !old_movie.streamer.include?(self)
          old_movie.streamer.to_a << self
        end
      else
        new_movie = Movie.new(movie)
        new_movie.streamer = self
        new_movie.add_attributes#.save
        self.movies << new_movie
      end
    end
  end

  def self.find_or_create_by_name(name)
    if !self.find_by_name(name)
      streamer = self.new(name)
      streamer.create_library
      streamer.save
    else
      self.find_by_name(name)
    end
  end

  def movies_by_genre(genre_name)
    genre_array = []
    genre = Genre.find_by_name(genre_name)
    genre.movies.each {|movie| genre_array << movie.name if movie.streamer == self.name }
    genre_array
  end
end
