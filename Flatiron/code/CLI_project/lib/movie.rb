# require_relative "./scraper"

class Movie
  extend SeekAndDestroyable
  attr_accessor :name, :year, :genre, :runtime, :synopsis, :streamer, :url
  @@all=[]

  def initialize(basic_info)
    @name=basic_info[:name]
    @url=basic_info[:url]
    @streamer=basic_info[:streamer]
  end

  def save
    @@all << self
  end

  def self.all
    @@all
  end

  # def self.create_by_streamer(streaming_service)
  #   library=Streamer.find_or_create_by_name(streaming_service)
  #   library.movies.each do |movie|
  #     if !self.find_by_name(movie.name)
  #       new_movie=Movie.new(movie).add_attributes
  #       new_movie.save
  #     else
  #       movie.streamer="#{movie.streamer}, #{library.name}"
  #     end
  #   end
  # end

  def add_attributes
    attributes=Scraper.movie_scraper(self.url)
    attributes.each do |k,v|
      self.send("#{k}=", v)
    end
  end

  def create_genre
    genre_array = self.genre.split(",")
    genre_array.each do |genre|
      Genre.new(genre).save unless Genre.find_by_name(genre)
    end
  end
end


  # def self.find_by_name(name)
  #   self.all.find {|movie| movie.name==name}
  # end


  # def self.destroy_all
  #   self.all.clear
  # end
