## Selecting words 
def selected_lengths(min=5,max=12)
    words = File.open('google-10000.txt','r'){|word_list| word_list.to_a}

    selected_words = words.filter {|word| word.length>min && word.length <= max+1 }
end

words_array = selected_lengths(2,3)

##

## Defining Classes
class Player
    attr_accessor :name,:guesses_made,:score

    def initialize(name, guesses_made = [], score = 0)
        @name = name
        @guesses_made = guesses_made
        @score = score
    end
end

class Game
    attr_accessor :word_to_guess, :player

    def initialize(player)
        @player = player
        @word_to_guess = ''
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
        puts "Please enter your guess"
        guess = gets[0].chomp

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
        puts "Would you like to play another round? [Y/N]"
        
        again = gets.chomp
        again.downcase!
        if again == 'y'
            return true
        elsif again == 'n'
            return false
        else
            play_again?
        end
    end
end

##

player = Player.new('player')
game = Game.new(player)
puts game.select_a_word(words_array)

loop do

    game.round

    if game.wins?
        game.display_word
        puts "You found the match!"

        if game.play_again? == true
            puts "score"
        else
            puts "Your score is : "+game.player.score.to_s
            break
        end
    end
end