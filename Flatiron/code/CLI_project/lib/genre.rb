class Genre
  extend SeekAndDestroyable
  attr_accessor :name, :movies
  @@all = []

  def initialize(name)
    @name = name
    @movies=[]
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

  # def self.find_or_create_by_movie(movie_name)
  #   movie = Movie.find_by_name(movie_name)
  #   if movie.genre == self
  #     self.movies << movie
  #   else
  #     new_genre=Genre.new(movie.genre)
  #     new_genre.save
  #     new_genre.movies << movie
  #   end
  # end

  # def self.find_by_name(name)
  #   self.all.find {|movie| movie.name==name}
  # end
end
