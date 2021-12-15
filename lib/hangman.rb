require "./lib/game.rb"
require "./lib/colors.rb"
require "yaml"

def save_game(name, current_game)

    unless Dir.exist?("saved_games")
        Dir.mkdir("saved_games")
    end

    if check_name(name)
        puts "this saved game already exists, do you want to overwrite it? (y/n)"
        overwrite = gets.chomp.downcase
        if overwrite == 'y'
            filename = "saved_games/#{name}.yaml"
        else
            puts "Input new name"
            new_name = gets.chomp
            filename = "saved_games/#{new_name}.yaml"
        end
    else
        filename = "saved_games/#{name}.yaml"
    end

    dump = YAML.dump(current_game)

    File.open(filename, "w") do |file|
        file.write dump
    end

    puts "Game saved successfuly"
end

def check_name(name)
    files = Dir.entries("saved_games")

    if files.include?("#{name}.yaml")
        true
    else 
        false
    end  
end

def load_game()
    saved_games = Dir.glob('saved_games/*').map { |file| file[(file.index('/') + 1)...(file.index('.'))] }

    puts "These are the current saved games, please choose the game you would like to load"

    puts saved_games

    game_to_load = gets.chomp

    raise "#{game_to_load} does not exist." unless saved_games.include?(game_to_load)

    puts "#{game_to_load} loaded..."

    filename = "saved_games/#{game_to_load}.yaml"

    saved = File.open(filename, "r")

    loaded_game = YAML.load(saved)

    saved.close

    loaded_game
end

puts "Welcome to Hangman"
puts "Please choose an option"
puts "1 - To play a game"
puts "2 - To load a saved game"

player_choice = gets.chomp

if player_choice == "1"
    game = Game.new
elsif player_choice == "2"
    game = load_game()
end

while game.check_guess? == false
    if game.get_guess == "save"
        puts "Please input name to save game"
        game_name = gets.chomp
        while game_name == ""
            puts "Invalid name, please input another name"
            game_name = gets.chomp
        end
        save_game(game_name, game)
        break
    end
end