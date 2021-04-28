class CommandLineInterface

  attr_accessor :streamer

  @@popular_streamers = ["Netflix","Hulu","Amazon Prime Video","Disney Plus","HBO Max","Criterion Channel"]
  @@all_streamers = ["Netflix","Netflix Kids","Hulu","Amazon Prime Video","Disney Plus","HBO Max","Criterion Channel","Apple TV Plus","Paramount Plus","Peacock","Peacock Premium","Google Play Movies","YouTube","Shudder","Hoopla","Kanopy","Funimation Now","IMDB TV","Vudu","Redbox","AMC Theaters","Popcornflix","Mubi","Starz","Showtime","Max Go","IndieFlix","TCM"]

  def run
  puts "Hello, my name is Rex!"
  puts "Having trouble picking a movie to watch? I can help you with that!"
  puts "I know the most popular movies for every streaming service."
  puts "Want me to give you a recommendation? (y/n)"

  initial_prompt = gets.strip
  case initial_prompt
    when "n"
      puts "Okay. Feel free to open me up next time you're picking a movie!"
      exit
    when "y"
      puts "Awesome. I'm happy to help!"
      self.pick_streamer
    end
  end

  def pick_streamer
    puts "Please pick a streaming service. Here are some of your options..."
    @@popular_streamers.each {|streamer| puts "#{streamer}"}
    puts "If you would like a list of all available streamers, type 'list streamers'..."
    puts "...otherwise please type in the name of the streaming service you would like me to sift through."

    @streamer_input = gets.strip

    if @streamer_input == "list streamers"
      puts "Okay, here are all available streamers as of today..."
      @@all_streamers.each {|streamer| puts "#{streamer}"}
      puts "Which streaming service would you like to choose?"
      @streamer_input = gets.strip
    else
      @streamer = Streamer.find_or_create_by_name(@streamer_input)
      self.pick_abc
    end
  end

  def pick_abc
    puts "Great! If you want I can either:"
    puts "A: List all available movies on #{@streamer_input},"
    puts "B: List all available movies by genre,"
    puts "or C: Make a recommendation right off the bat!"
    puts "Which option would you like to choose: A, B or C?"

    abc_input = gets.strip
    case abc_input
    when "A" || "a"
        self.list_movies

      when "B" || "b"
        self.list_genres

      when "C" || "c"
        self.make_recommendation
      end
    end

    def list_movies
      num = 1
      movies = Movie.all.map {|movie| movie if movie.streamer == @streamer_input}
      movies.each do |movie|
        puts "#{num}. #{movie.name}"
        num+=1
      end
      puts "Would you like me to recommend something from this list? (y/n)"
      input = gets.strip
      case input
      when "y" || "yes"
        self.make_recommendation
      when "n" || "no"
        puts "Okay, why don't you try picking another streaming service..."
        self.pick_streamer
      end
    end

    def list_genres
      puts "Okay, which genre would you like to choose? Here are your options..."
      num=1
      self.streamer.genres.each do |genre|
        puts "#{num}. #{genre}"
        num+=1
      end
      @genre_input = gets.strip
      self.make_recommendation_by_genre
    end

    def make_recommendation
      puts "Okay, here is the movie I'd like to recommend to you..."
      last_one = self.streamer.movies.length
      rec = self.streamer.movies[rand(1..last_one)]
      puts "..."
      puts rec.name
      puts "Year: #{rec.year}"
      puts "Genre: #{rec.genre.join(", ")}"
      puts "Runtime: #{rec.runtime}"
      puts "Synopsis: #{rec.synopsis}"
      puts "..."
      self.postscript
    end

    def make_recommendation_by_genre
      # streamer = Streamer.find_by_name(@streamer_input)
      genre_movies = self.streamer.movies_by_genre(@genre_input)
      last = genre_movies.length
      genre_rec = genre_movies[rand(1..last)]
      puts "Okay, here is the #{genre_input} film that I would like to recommend to you..."
      puts "..."
      puts genre_rec.name
      puts "Year: #{genre_rec.year}"
      puts "Genre: #{genre_rec.genre.join(", ")}"
      puts "Runtime: #{genre_rec.runtime}"
      puts "Synopsis: #{genre_rec.synopsis}"
      puts "..."
      self.postscript
    end

    def postscript
      puts "I hope you like it! If you'd like another recommendation, just type the word \"recommend\" below."
      puts "Or if you'd like to start from scratch with a new streamer, just type the word \"rerun\"."
      puts "If you like this recommendation, you can close the program by simply typing \"end\"."
      input = gets.strip
      case input
      when "recommend"
        self.pick_abc
      when "rerun"
        self.run
      when "end"
        puts "Thanks. Enjoy the movie!"
        exit
      end
    end
  end
