class Streamer
  extend SeekAndDestroyable

  attr_accessor :name, :movies, :genres
  @@all=[]

  def initialize(name)
    #binding.pry
    @name = name
    @movies = []
    @genres = []
    self.create_library
  end

  def save
    @@all << self
  end

  def self.all
    @@all
  end

  def create_library
    library = Scraper.streamer_scraper(self.name)
    library.each do |movie_hash|
      new_movie = Movie.new(movie_hash).add_attributes.save
      #new_movie.streamer = self.name
      @movies << new_movie
    end
    @movies
  end

  def self.find_or_create_by_name(name)
    if !self.find_by_name(name)
      streamer = self.new(name)
      streamer.save
    else
      self.find_by_name(name)
    end
  end

  def genres
    binding.pry
    self.movies.each do |movie|
      movie.genre.each {|genre| @genres << genre unless @genres.include?(genre)}
    end
    @genres
  end

  def movies_by_genre(genre_name)
    genre = self.genres.find {|genre| genre == genre_name}
    genre.movies.map {|movie| movie.streamer == self}
  end
end
