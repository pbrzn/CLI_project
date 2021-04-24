# require_relative './scraper'
# require_relative './movie'

class Streamer
  extend SeekAndDestroyable
  attr_accessor :name, :movies
  @@all=[]

  def initialize(name)
    @name=name
    @movies=[]
  end

  def save
    @@all << self
  end

  def self.all
    @@all
  end

  # def self.find_by_name(name)
  #   self.all.find {|streamer| streamer.name==name}
  # end

  def self.find_or_create_by_name(name)
    if !self.find_by_name(name)
      streamer = self.new(name).save
      streamer.create_library
    else
      self.find_by_name(name)
    end
  end

  def create_library
    library = Scraper.streamer_scraper(name)
    library.each do |movie|
      if Movie.find_by_name(movie[:name])
        old_movie=Movie.find_by_name(movie[:name])
        old_streamer=old_movie.streamer
        old_movie.streamer = "#{old_streamer}, #{self.name}"
      else
        new_movie=Movie.new(movie).add_attributes.save
        self.movies << new_movie
      end
    end
  end

  def movies_by_genre(genre_name)
    genre_array = []
    genre=Genre.find_by_name(genre_name)
    genre.movies.each {|movie| genre_array << movie.name if movie.streamer == self.name }
    genre_array
  end

  # def self.destroy_all
  #   self.all.clear
  # end
end
