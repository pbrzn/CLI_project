class Genre
  extend SeekAndDestroyable
  attr_accessor :name, :movies, :streamers
  @@all = []

  def initialize(name)
    @name = name
  end

  def self.all
    @@all
  end

  def save
    @@all << self
  end

  def self.find_or_create_by_movie(movie)
    @movies = []
    movie.genre.each do |genre|
      if !self.find_by_name(genre)
        new_genre=Genre.new(genre)
        new_genre.save
        @movies << movie
      else
        self.movies << movie
      end
    end
  end
end
