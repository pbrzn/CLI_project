class Genre
  extend FindableAndDestructible
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

  def self.find_or_create_by_name(name)
    if 
    else
      new_genre=Genre.new(movie.genre)
      new_genre.save
      new_genre.movies << movie
    end
  end

  def movies
    @movies
  end

  # def self.find_by_name(name)
  #   self.all.find {|movie| movie.name==name}
  # end
end
