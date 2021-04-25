class Genre
  extend SeekAndDestroyable
  attr_accessor :name, :movies, :streamers
  @@all = []

  def initialize(name)
    @name = name
    @movies = []
    @streamers = []
  end

  def self.all
    @@all
  end

  def save
    @@all << self
  end

  def self.find_or_create_by_movie(movie)
    movie.genre.each do |genre|
      if !self.find_by_name(genre)
        new_genre=Genre.new(genre).save
        new_genre.movies << movie
        new_genre
      else
        self.movies << movie.name
        self
      end
    end
  end
end
