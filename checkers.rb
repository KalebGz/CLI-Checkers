require 'active_record'
require_relative 'config/environment'
require "tty-prompt"

$prompt = TTY::Prompt.new
puts "-------------|"
puts "CLI CHECKERS"

# finds/creates and greets player 1
puts "Player 1: What is your name?"
player_1 = Player.find_or_create_by_name(gets.chomp)
puts "-----------------------------\n"

# finds/creates and greets player 2
puts "Player 2: What is your name?"
player_2 = Player.find_or_create_by_name(gets.chomp)
puts "-----------------------------\n"

# tries to load existing game
game = Board.all.find{ |board| player_1.boards.member?(board) && player_2.boards.member?(board)}
if game # there is an existing game
    puts "You have a saved game in progress."
    # ask the user if they want to continue existing game or start new
    loop do
        if $prompt.select("What would you like to do?", {"Continue saved game" => true, "Start new game" => false})
            puts "Loading saved game..."
            break
        elsif $prompt.yes?("Are you sure? Your saved game will be overwritten")
            puts "Creating new game..."
            game.destroy # overwrites existing game
            game = Board.create(l_player: player_1, r_player: player_2)
            break
        end
    end
else
    puts "Creating new game..."
    game = Board.create(l_player: player_1, r_player: player_2)
end

# Print out which side which side each player is
puts "#{game.l_player.name}: Blue Team"
puts "#{game.r_player.name}: Red Team"
    
# 21:30

game.load
start_game(game)

def start_game(board)
    loop do 
        move = get_move(board)
        move_type = validate_move(move[:piece], move[:to_x], move[:to_y]) # Returns nil if its not a valid move
        if(move_type == nil)
            puts "That is not a valid move"
        end
        execute_move(move[:piece], move_type, move[:to_x], move[:to_y])
        board.switch_player
        board.update
        board.display
    end
end

def get_move(board)
    move = {:to_X => nil, :to_Y => nil,:piece => nil}
    loop do
        puts "Please enter your move in the proper format, ex. '11:23'" 
        move_input = gets.chomp
        move_input = move_input.split(":")
        if(!move_input =~ (/^[A-Ha-h][1-8]:[A-Ha-h][1-8]$/)) 
            puts "Please enter your move in the proper format, ex. '11:23'" 
            next #restart get_move loop
        end
        move_input = move_input.split(":")
        from_pos = move_input[0].to_s.to_i
        to_pos = move_input[1].to_s.to_i
        
        move[:to_X] = to_pos[0]
        move[:to_Y] = to_pos[1]
        move[:piece] = Piece.all.find{|piece|piece.x_pos = from_pos[0] && piece.y_pos = from_pos[1]}
        if(!move[:piece])
            puts "There is no piece to move in the specified square\n"
            next #restart get_move loop
        end
        if(move[:piece].team != board.player_turn)
            binding.pry
            puts "You can not move your opponent’s piece\n"
            next #restart get_move loop
        end
    
        break # A proper move was inputted
    end
    return move
end

# returns move type as a string if valid, nil if invalid
def validate_move(piece, to_pos)
    if piece.regular_moves.include?(to_pos) # if its a regular move
        return "regular"
    elsif piece.jump_moves.include?(to_pos) # if its a jump move
        return "jump"
    else # if it is not a valid move
        return nil
    end
end

def execute_move(piece, move_type, to_pos, game)
    # parses destination coordinate array into individual x and y values
    to_x = to_pos[0]
    to_y = to_pos[1]

    if move_type == "regular"
        # set the piece to its new position, updates board
        piece.x_pos = to_x
        piece.y_pos = to_y
        game.update
        return true # move is complete

    elsif move_type == "jump"
        loop do # runs until all jump moves have been exhausted
            # remembers the starting position of the piece
            from_x = piece.x_pos
            from_y = piece.y_pos

            # set the piece to its new position, updates board
            piece.x_pos = to_x
            piece.y_pos = to_y
            game.update

            # finds captured piece and removes it from the piece.all array - ruby will garbage collect
            Piece.all.delete(Piece.all.find{|p| p.x_pos == (from_x + to_x)/2 && p.y_pos == (from_y + to_y)/2})

            # recalculates posisble jump moves and checks if there are any left
            if piece.jump_moves.empty?
                return true # move is complete
            else
                loop do # runs until the user provides a valid jump move destination
                    jump_input = gets("Please provide the coordinates of your next jump.")

                    if /^[A-Ha-h][1-8]$/.match(jump_input) # the user has provided a coordinate in correct format
                        to_pos = jump_input.split("") # splits input string into an array [x,y]
                        to_pos[0] = to_pos[0].to_i # converts letter x-coord to number

                        if piece.jump_moves.include?(to_pos) # if the user input coordinate is indeed a jump move
                            # parses destination coordinate array into individual x and y values
                            to_x = to_pos[0]
                            to_y = to_pos[1]

                            break # exits into main loop to execute another jump move
                        else # if the user input coordinate is not a jump move
                            puts "You must jump over an opponent piece."
                        end
                    else # the user has not provided a coordinate in wrong format
                        puts "That is not a valid coordinate. Examples: 'A2', 'g5'"
                    end
                end
            end
        end
    end

    # # switches player to the next one
    # if game.player_turn == "l"
    #     game.player_turn = "r"
    # else
    #     game.player_turn = "l"
    # end

    # saves updated board to database
    game.save
end


