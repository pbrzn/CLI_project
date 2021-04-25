class Movie
  extend SeekAndDestroyable
  attr_accessor :name, :year, :genre, :runtime, :synopsis, :streamer, :url
  @@all = []

  def initialize(basic_info)
    @name = basic_info[:name]
    @url = basic_info[:url]
    @streamer = basic_info[:streamer]
    @@all << self
  end

  # def save
  #   @@all << self
  # end

  def self.all
    @@all
  end

  def add_attributes
    attributes = Scraper.movie_scraper(self.url)
    attributes.each do |k,v|
      self.send("#{k}=", v)
    end
    self
  end

  def find_or_create_genres
    genre = Genre.find_or_create_by_movie(self)
  end
end
