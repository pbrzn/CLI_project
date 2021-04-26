class Streamer
  extend SeekAndDestroyable
  attr_accessor :name, :movies, :genres
  @@all=[]

  def initialize(name)
    @name = name
  end

  def save
    @@all << self
  end

  def self.all
    @@all
  end

  def create_library
    @movies = []
    library = Scraper.streamer_scraper(self.name)
    library.each do |movie|
      new_movie = Movie.new(movie)
      new_movie.streamer = self
      new_movie.add_attributes#.save
      @movies << new_movie
    end
  end

  def self.find_or_create_by_name(name)
    if !self.find_by_name(name)
      streamer = self.new(name)
      #streamer.create_library
      streamer.save
    else
      self.find_by_name(name)
    end
  end

  def genres
    @genres = []
    self.movies.each do |movie|
      movie.genre.each {|genre| @genres << genre unless @genres.include?(genre)}
    end
  end

  # def movies_by_genre(genre_name)
  #   genre = self.genres.find {|genre| genre == genre_name}
  #   genre.movies.map {|movie| movie.streamer == self}
  # end
end
