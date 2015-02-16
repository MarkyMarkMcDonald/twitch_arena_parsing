class ArenaGameExtractor
  Game = Struct.new(:start, :finish)

  def initialize(timestamps)
    @timestamps = timestamps
  end

  def games
    in_game = false
    @timestamps.each_cons(2).inject([]) do |games, (first_timestamp, second_timestamp)|
      if second_timestamp - first_timestamp > 1
        if !in_game
          games << Game.new(first_timestamp, second_timestamp)
        end
        in_game = !in_game
      end
      games
    end
  end
end
