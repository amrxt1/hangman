## Selecting words 
def selected_lengths(min=5,max=12)
    words = File.open('google-10000.txt','r'){|word_list| word_list.to_a}

    selected_words = words.filter {|word| word.length>=min && word.length <=max }
end

words_array = selected_lengths(5,12)

##

## Defining Classes
class Player
    attr_accessor :name,:guesses_made,:score

    def initialize(name, guesses_made = '', score = 0)
        @name = name
        @guesses_made = guesses_made
        @score = score
    end
end

class Game
    def initialize(player)
        @player = player
        @word_to_guess = ''
    end
end
