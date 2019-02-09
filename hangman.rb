require 'yaml'
game_over = false
random_word = ""
hidden_word = ""
guesses = 0
history = []

def save_state(guesses, random_word, hidden_word, history)
    game_state = [guesses, random_word, hidden_word, history]
    serialized_object = YAML::dump(game_state)
    game_file = open('save_game.yaml', 'w')
    game_file.puts serialized_object
    game_file.close
end

def reset_game
    word_list = []
    File.open('5desk.txt').readlines.each do |line|
        word_list << line
    end
    word_list.select! {|word| word.rstrip.length > 5 && word.rstrip.length < 13}
    random_word = word_list.sample.downcase.rstrip!
    hidden_word = random_word.gsub(/\D/, "*")
    guesses = 8
    history = []
    return [random_word, hidden_word, guesses, history]
end

puts "Welcome to Hangman! If you would like to load a saved game, input 'load'. If you would like to start a new game, input 'new' Input 'save' at any time to save your game."

game_type = nil
while game_type != 'load' && game_type != 'new'
    game_type = gets.chomp.downcase
end

if game_type == 'load'
    game_file = open('save_game.yaml', 'r')
    game_state = YAML::load(game_file.read)
    game_file.close
    guesses = game_state[0]
    random_word = game_state[1]
    hidden_word = game_state[2]
    history = game_state[3]
elsif game_type == 'new'
    game_state = reset_game
    random_word, hidden_word, guesses, history = game_state[0], game_state[1], game_state[2], game_state[3]
end

while game_over == false
    puts "Hidden word is: #{hidden_word}"
    puts "Guess a letter"
    puts "Already guessed: #{history.join('/')}"
    guess = gets.chomp.downcase
    if guess == 'save'
        save_state(guesses, random_word, hidden_word, history)
        game_over = true
        next
    end
    guess = guess.match(/[\D]/).to_s
    history << guess
    if random_word.include? guess
       correct_indexes = random_word.split("").each_index.select {|i| random_word[i] == guess}
       correct_indexes.each {|index| hidden_word[index] = guess}
       puts "You guessed a correct letter!"
       if !hidden_word.include? "*"
            puts "You win! The word was #{random_word}" 
            game_state = reset_game
            random_word, hidden_word, guesses, history = game_state[0], game_state[1], game_state[2], game_state[3]
            save_state(guesses, random_word, hidden_word, history)
            game_over = true 
       end
    else
       guesses -= 1  
       puts "Wrong! You have #{guesses} guesses left!"
       if guesses == 0
            puts "No guesses left! Game over!"
            puts "The word was #{random_word}"
            game_state = reset_game
            random_word, hidden_word, guesses, history = game_state[0], game_state[1], game_state[2], game_state[3]
            save_state(guesses, random_word, hidden_word, history)
            game_over = true 
       end
    end
end


