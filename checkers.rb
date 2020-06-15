require 'active_record'
require_relative 'config/environment'
require "tty-prompt"

$prompt = TTY::Prompt.new

system("clear") || system("cls")

puts "\n"
puts "⬜⬛⬜⬛⬜⬛⬜⬛⬜⬛"
puts "⬛🔵CLI CHECKERS🔴⬜"
puts "⬜⬛⬜⬛⬜⬛⬜⬛⬜⬛\n\n"

# asks user if they want to see leaderboard
loop do # keeps running until the user wants to exit the leaderboard
    # exit into main flow if user chooses to play checkers
    break if $prompt.select("🤔What would you like to do?", {"👉Play checkers" => true, "👉See leaderboard" => false})
    system("clear") || system("cls")
    leaderboard = Player.order(win_count: :desc).limit(5)
    puts "\n*******🔥🔥LEADERBOARD🔥🔥*********"
    puts "\nWins.....Player....................."
    puts "\n"
    for player in leaderboard
        puts "#{"%04d" % player.win_count}     ✨#{player.name}"
    end
    puts "\n"
    $prompt.keypress("🚪🚶Press any key to return to menu....")
end

system("clear") || system("cls")
# finds/creates and greets player 1
puts "✨Player 1: What is your name?✨"
player_1 = Player.find_or_create_by_name(gets.chomp)
puts "-----------------------------\n"

# finds/creates and greets player 2
puts "✨Player 2: What is your name?✨"
player_2 = Player.find_or_create_by_name(gets.chomp)
puts "-----------------------------\n"

# tries to load existing game
game = Board.all.find{ |board| player_1.boards.member?(board) && player_2.boards.member?(board)}

if game # there is an existing game
    puts "💾You have a saved game in progress."
    
    # ask the user if they want to continue existing game or start new
    loop do # runs until the user chooses to continue existing game or confirms create new game
        if $prompt.select("🤔What would you like to do?", {"👉Continue saved game" => true, "👉Start new game" => false})
            puts "⏳Loading saved game..."
            break
        elsif $prompt.yes?("🗑️Are you sure? Your saved game will be overwritten")
            puts "⏳Creating new game..."
            game.destroy # overwrites existing game
            # creates new game and loads into game variable
            game = Board.create(l_player: player_1, r_player: player_2)
            break
        end
    end
else
    # Creates new game and loads into game variable
    puts "⏳Creating new game..."
    game = Board.create(l_player: player_1, r_player: player_2)
end


# DEBUG

#     # test double jump 
# game.content = [
#     "⬜🔵⬜⬛⬜⬛⬜🔴",
#     "⬛⬜🔵⬜🔴⬜🔴⬜",
#     "⬜🔵⬜🔵⬜🔴⬜🔴",
#     "🔵⬜⬛⬜⬛⬜🔴⬜",
#     "⬜🔵⬜🔵⬜🔴⬜🔴",
#     "🔵⬜🔵⬜🔴⬜⬛⬜",
#     "⬜🔵⬜⬛⬜🔴⬜🔴",
#     "🔵⬜🔵⬜⬛⬜🔴⬜"
# ].join("\n")

#      test win
# game.content = [
#     "⬜⬛⬜⬛⬜⬛⬜⬛",
#     "⬛⬜⬛⬜⬛⬜⬛⬜",
#     "⬜⬛⬜🔴⬜⬛⬜⬛",
#     "⬛⬜🔵⬜⬛⬜⬛⬜",
#     "⬜⬛⬜⬛⬜⬛⬜⬛",
#     "⬛⬜⬛⬜⬛⬜⬛⬜",
#     "⬜⬛⬜⬛⬜⬛⬜⬛",
#     "⬛⬜⬛⬜⬛⬜⬛⬜"
# ].join("\n")


# Create piece instances according to the configuration stored in board instance
game.load

# Let the status message linger for a bit to make it seem like the program is working
sleep(1)

# Print out which side which side each player is
puts "#{game.l_player.name}: 🔵Blue Team"
puts "#{game.r_player.name}: 🔴Red Team"

# Ask for keypress to start
$prompt.keypress("🏁Press any key to begin...")

# Display the current board
game.display

# Display the current player's turn
game.display_turn

# Cycle of getting, validating, and executing moves; checks for win condition and switches player
loop do # runs until a winner is determined
    player_move = {}
    move_type = ""
    # Ask the player for a move
    loop do # runs until the player inputs a valid move
        player_move = game.get_move # parse player input into coordinates

        # validates move
        move_type = game.validate_move(player_move[:piece], player_move[:to_pos]) # Returns nil if its not a valid move
        
        # exit this loop if the move is valid
        break if move_type

        # print error and restart if the move isn't valid
        puts "😢That is not a valid move."
    end

    # Now that a valid move has been provided, execute it!
    game.exc_move(player_move[:piece], move_type, player_move[:to_pos])

    # Checks if someone has won, and breaks out of loop if so
    if(Piece.all.none?{|p| p.team == "r"} || Piece.all.none?{|p| p.team == "l"})
        game.game_over
        break
    end
    

    # Now that the player's turn has finished, switch to the next player!
    game.switch_turn

    # Saves new board configuration to database
    game.save

    # Display the current board
    game.display

    # Display the current player's turn
    game.display_turn
end





    # # switches player to the next one
    # if game.player_turn == "l"
    #     game.player_turn = "r"
    # else
    #     game.player_turn = "l"
    # end

# saves updated board to database


