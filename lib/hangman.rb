def selected_lengths(min=5,max=12)
    words = File.open('google-10000.txt','r'){|word_list| word_list.to_a}

    selected_words = words.filter {|word| word.length>=min && word.length <=max }
end

words_array = selected_lengths(5,12)

puts words_array.length