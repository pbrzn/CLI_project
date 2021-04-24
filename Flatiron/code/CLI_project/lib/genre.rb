class Genre
  extend SeekAndDestroyable
  attr_accessor :name, :movies
  @@all = []

  def initialize(name)
    @name = name
    @movies = []
  end

  def self.all
    @@all
  end

  def save
    @@all << self
  end

  def movies
    @movies
  end

  def self.find_or_create_by_movie(movie)
    movie.genre.each do |genre|
      if self.find_by_name(genre)
        self.movies << movie
        self
      else
        new_genre=Genre.new(genre)
        new_genre.save
        new_genre.movies << movie
      end
    end
  end
end
