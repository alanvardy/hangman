class Game
  def initialize
    @answer = load_word
    @guesses = ""
    @bad_guesses = 0
    @BAD_GUESSES_ALLOWED = 5
    @game_over = false
    play_game until @game_over == true
    end_game
  end

  def load_word(filename = "5d+2a.txt")
    file = File.open(filename)
    dictionary = file.select {|line| (line.chomp.length > 4 && line.chomp.length < 13)}
    dictionary[rand(dictionary.length)].chomp
  end

  def play_game
    print_display
    enter_guess
  end

  def print_display
    12.times {print "-"}
    puts "\nGuess the letter!"
    puts placeholder
    puts "Guesses so far: #{@guesses}"
    puts "Bad guesses left: #{@BAD_GUESSES_ALLOWED - @bad_guesses}"
  end

  def placeholder
    placeholder = ""
    @answer.chars do |char|
      @guesses.include?(char) ? placeholder << char : placeholder << "_"
    end
    placeholder.chars.join(" ")
  end

  def enter_guess
    guess = nil
    until ("a".."z").include?(guess) do
      print "Enter your guess: "
      guess = gets.chomp
    end
    if @answer.include?(guess) && @guesses.include?(guess)
      puts "You already guessed this!"
    elsif @answer.include?(guess)
      puts "Good guess!"
      @guesses << guess
    else
      puts "Sorry!"
      @guesses << guess
      @bad_guesses += 1
    end
    @game_over = true if (@bad_guesses >= @BAD_GUESSES_ALLOWED || answer_guessed?)
    puts "\n\n"
  end

  def answer_guessed?
    @answer.chars do |char|
      return false unless @guesses.include?(char)
    end
    return true
  end

  def end_game
    puts answer_guessed? ? "You Win!\n\n" : "You Lose!\n\n"
  end
end

Game.new