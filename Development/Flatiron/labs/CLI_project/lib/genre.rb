class Genre
  extend SeekAndDestroyable
  attr_accessor :name, :movies, :streamers
  @@all = []

  def initialize(name)
    @name = name
    # @movies = []
  end

  def self.all
    @@all
  end

  def save
    @@all << self
  end

  def self.find_or_create_by_movie(movie)
    @movies = []
    movie.genre.map do |genre|
      if !self.find_by_name(genre)
        new_genre=Genre.new(genre)
        new_genre.save
        @movies << movie
      else
        @movies << movie
      end
    end
  end

  def movies
    @movies
  end

  def streamers
    @streamers = []
    self.movies.all {|movie| @streamers << movie.streamer }
    @streamers
  end
end
