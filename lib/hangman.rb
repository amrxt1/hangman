require 'pry-byebug'
require 'json'
## Selecting words 
def selected_lengths(min=5,max=12)
    words = File.open('google-10000.txt','r'){|word_list| word_list.to_a}

    selected_words = words.filter {|word| word.length>min && word.length <= max+1 }
end

WORDS_ARRAY = selected_lengths(2,3)

##

## Defining Classes
class Player
    attr_accessor :name,:guesses_made,:score

    def initialize(name, guesses_made = [], score = 0)
        @name = name
        @guesses_made = guesses_made
        @score = score
    end

    def reset
        self.guesses_made = []
    end
    def to_json(e)
        JSON.dump({
            :name => @name,
            :guesses_made => @guesses_made,
            :score => @score
        })
    end

    def self.from_json(string)
        data = JSON.load string
        self.new(data['name'],data['guesses_made'],data['score'])
    end
    
end

class Game
    attr_accessor :word_to_guess, :player, :guess_limiter
    def initialize(player, word_to_guess = '', guess_limiter = 15)
        @player = player
        @word_to_guess = word_to_guess
        @guess_limiter = guess_limiter
    end


    def to_json
        JSON.dump({
            :word_to_guess => @word_to_guess,
            :player => @player,
            :guess_limiter => @guess_limiter
        })
    end

    def self.from_json(string)
        data = JSON.load(string)
        player_data = data['player']
        player = Player.new(player_data['name'],player_data['guesses_made'],player_data['score'])
        binding.pry
        self.new(player,data['word_to_guess'],data['guess_limiter'])
    end

    def select_a_word(list)
        @word_to_guess = list.sample(1)
    end

    def display_word       
        self.word_to_guess = self.word_to_guess.join.chomp.split('')

        self.word_to_guess.each do |letter|
            self.player.guesses_made.include?(letter) ? (print letter+" ") : (print "_ ")
        end
        puts ""
    end

    def valid_guess?(guess)
        !self.player.guesses_made.include?(guess)
    end

    def make_a_guess
        puts "Please enter your guess                In order to save the game here, enter 1"
        guess = gets[0].chomp
        guess.downcase!

        if guess == '1'
            pp self
            return
        end

        if guess == ''
            make_a_guess
        elsif valid_guess? guess
            #update guess
            self.player.guesses_made.push(guess)
        else
            puts "Invalid! You already made that guess."
            make_a_guess
        end
    end

    def wins?
        (self.word_to_guess - self.player.guesses_made).empty?
    end

    def round
        self.display_word
        self.make_a_guess
    end

    def play_again?

        puts "Your score is : "+self.player.score.to_s

        puts "Would you like to play another round? [Y/N]"
        
        again = gets.chomp
        again.downcase!
        if again == 'y'
            self.select_a_word(WORDS_ARRAY)
            return true
        elsif again == 'n'
            return false
        else
            play_again?
        end
    end
end

##

## Code implementation
player = Player.new('player')
game = Game.new(player)
puts game.select_a_word(WORDS_ARRAY)

counter = 0
loop do
    
    x = game.to_json
    y = File.open('game','w')
    y.puts x
    y.close

    puts "\n game from json"
    g = Game.from_json(File.read('game'))
    p g
    puts "\nOG game"
    p game
    game.round
    counter += 1
    puts "\nGuesses left : #{game.guess_limiter - counter}"
    
    if counter == game.guess_limiter
        puts "Alas! you ran out of guesses"
        puts "The word was : #{game.word_to_guess.join}"
        
        if game.play_again?
            game.player.reset
            counter = 0
        else
            puts "Have a great the rest of your day"
            break
        end
    end


    if game.wins?
        game.display_word
        puts "\nYou found the match!"
        game.player.score += 1

        if game.play_again?
            game.player.reset
            counter = 0
        else
            puts "Have a great the rest of your day"
            break
        end
    end
end

##