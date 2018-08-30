require "pstore"

class Game

  attr_accessor :game_over, :save_game

  def initialize
    puts "\nWELCOME TO HANGMAN!\n\n"
    @answer = load_word
    @guesses = ""
    @bad_guesses = 0
    @BAD_GUESSES_ALLOWED = 5
    @game_over = false
    @save_game = false
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
    puts "\nGuess the letter!\n\n"
    puts placeholder
    puts "\nGuesses so far: #{@guesses}"
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
      print "Enter your guess, or type \'save\' to save the game: "
      guess = gets.chomp
      if guess == "save"
        @save_game = true
        return
      end
    end
    if @guesses.include?(guess)
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

def save_to_file(game)
  store = PStore.new("hangman.sav")
  store.transaction do
    store[:game] = game
  end
  puts "Game Saved!"
end

def load_from_file
  store = PStore.new("hangman.sav")
  store.transaction do
    game = store[:game]
  end
  puts "Game loaded!"
  game
end

def game_loop(game)
  game.save_game = false
  game.play_game until game.game_over || game.save_game
  game.end_game if game.game_over
  save_to_file(game) if game.save_game
end

while true
  print "Welcome to Hangman!\nMain Menu\n(n)ew game\n(l)oad game\ne(x)it\n>>"
  input = gets.chomp
  case input
  when "n"
    puts "new game"
    game = Game.new
    game_loop(game)
  when "l"
    game = load_from_file
    game_loop(game)
  when "x"
    puts "Goodbye!"
    break
  else
    puts "Invalid entry. Please try again"
  end
end