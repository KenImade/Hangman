class Game

    def initialize
        @secret_word = create_secret_word()
        @char_guessed = ""
        for i in 0..@secret_word.length-1 do
            @char_guessed += "_"
        end
        @guesses = []
        @turns = @secret_word.length + 3
    end

    def create_secret_word()
        dictionary = File.open("5desk.txt")

        word_bank = dictionary.readlines.map(&:chomp)

        secret_word = word_bank[Random.rand(0..(word_bank.length-1))].downcase
        

        while secret_word.length < 5 || secret_word.length > 12
            secret_word = word_bank[Random.rand(0..(word_bank.length-1))].downcase
        end

        secret_word
    end

    def display_game()

        puts "Letters used so far: #{@guesses.join(" ")}"

        puts @char_guessed
    end

    def get_guess()

        puts "Guess a letter"

        puts "To save the game input save"

        display_game()

        player_guess = gets.chomp.downcase

        if player_guess == "save"
            return "save"
        else 

            while ("a".."z").include?(player_guess) == false

                puts "Invalid input, Please input a single letter"

                player_guess = gets.chomp.downcase

            end

            while @guesses.include?(player_guess.red) || @guesses.include?(player_guess.green)
                puts "You've already used this letter!, input a new letter or inputs save to save the game"
                player_guess = gets.chomp.downcase
                if player_guess == "save"
                    return "save"
                end
            end

            guess_word(player_guess)
        end
        
        puts "You have #{@turns} more tries"
        @turns -= 1
    end

    def guess_word(player_guess)

        if @secret_word.include?(player_guess)

            char_index = get_char_index(player_guess)
    
            for index in char_index
                @char_guessed[index] = player_guess
            end
        else
            puts "Wrong guess!"
        end
        append_guess(player_guess)
        display_game()
    end

    def append_guess(player_guess)
        if @secret_word.include?(player_guess)
            player_guess = player_guess.green
        else
            player_guess = player_guess.red
        end
        @guesses << player_guess
    end

    def get_char_index(char)
        index = 0
        all_index = []
        @secret_word.each_char do |letter|
            if letter == char
                all_index << index
            end
            index += 1
        end
        all_index
    end

    def check_guess?()
        if @secret_word == @char_guessed
            puts "You guessed the Word!"
            true
        elsif @turns == 0
            puts "You have no more turns! The secret word is #{@secret_word}"
            true
        else
            false
        end
    end

end