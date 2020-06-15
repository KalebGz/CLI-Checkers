class Board < ActiveRecord::Base # instances of this class are stored in the boards table of the database
    
    belongs_to :l_player, :class_name => 'Player', :foreign_key => 'l_player_id'
    belongs_to :r_player, :class_name => 'Player', :foreign_key => 'r_player_id'
    
    # Creates the pieces associatied with the current board configuration
    def load
        grid = content.split("\n")
        grid.length.times{|row|
                grid[row].length.times{|col|
                if grid[row][col] == "🔴"
                    Piece.new(row, col, "r", "🔴")
                elsif grid[row][col] == "🔵"
                    Piece.new(row, col, "l", "🔵")
                end
            }
        }
    end

    # Prints out the current configuration of this board's content along with axes labels
    def display        
        system("clear") || system("cls")

        grid = content.split("\n")
        print " " # make grid line up
        grid.length.times{|num| print " #{num + 1}"}
        grid.length.times{|row|
            puts ""
            print (65+row).chr + " "
            grid[row].length.times{|col|
                print grid[row][col] 
        }
    }
    puts ""
    end

    def display_turn
        if(self.player_turn == 'l')
            puts "🔵It is #{self.l_player.name}'s turn!🔵"
        else
            puts "🔴It is #{self.r_player.name}'s turn!🔴"
        end
    end

    def switch_turn
        if(self.player_turn == 'l')
            self.player_turn = 'r'
        else
            self.player_turn = 'l'
        end
    end

    # Looks through coordinates stored in all pieces and “arrange” them in self.contents
    # TODO: try more efficient code
    def update

        new_board = [
            "⬜⬛⬜⬛⬜⬛⬜⬛",
            "⬛⬜⬛⬜⬛⬜⬛⬜",
            "⬜⬛⬜⬛⬜⬛⬜⬛",
            "⬛⬜⬛⬜⬛⬜⬛⬜",
            "⬜⬛⬜⬛⬜⬛⬜⬛",
            "⬛⬜⬛⬜⬛⬜⬛⬜",
            "⬜⬛⬜⬛⬜⬛⬜⬛",
            "⬛⬜⬛⬜⬛⬜⬛⬜"]

        Piece.all.each{|piece| new_board[piece.x_pos][piece.y_pos] = piece.symbol}
        # binding.pry
        self.content = new_board.join("\n")
    end

    # Gets a move from the player, parses it into coordinates, and check that player is trying to move one of their own pieces
    def get_move
        move = {}
        loop do # Runs until a valid move is provided
            # Gets input from user
            puts "🤔What move would you like to make?" 
            # binding.pry
            input = gets.chomp.upcase


            # Check input format using regex
            if /^[A-H][1-8]:[A-H][1-8]$/.match(input) # input is properly formatted
                move_input = input.split(":")
                from_pos = move_input[0].split("")
                from_pos[0] = from_pos[0].ord - 65 # converts letter x-coord to number
                from_pos[1] = from_pos[1].to_i - 1 # converts 1-indexed user input to 0-indexed internal coords

                to_pos = move_input[1].split("")
                to_pos[0] = to_pos[0].ord - 65 # converts letter x-coord to number
                to_pos[1] = to_pos[1].to_i - 1 # converts 1-indexed user input to 0-indexed internal coords
                
                move[:to_pos] = [to_pos[0], to_pos[1]] # parse to_pos into individual coordinates

                # Check if there is a piece at the starting point
                move[:piece] = Piece.all.find{|piece|piece.x_pos == from_pos[0] && piece.y_pos == from_pos[1]}
                if move[:piece] # there is a piece

                    # Check if the piece belongs to the player
                    if move[:piece].team == self.player_turn # the piece belongs to the current player
                        return move # returns the move hash, exits loop
                    else # the piece doesn't belong to the current player
                        puts "😢You cannot move your opponent's piece"
                    end

                else # there is no piece
                    puts "😢There is no piece to move in the specified square"
                    # will restart loop
                end

            else # input is not properly formatted
                # Check to see if the user wants to exit the program 
                if(input == "EXIT")
                    exit(0)
                end
                puts "🥺Please enter your move in the proper format, ex. 'A1:h8'"
                # will restart loop
            end
        end
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
    
    def exc_move(piece, move_type, to_pos)
        # parses destination coordinate array into individual x and y values
        to_x = to_pos[0]
        to_y = to_pos[1]
    
        if move_type == "regular"
            # set the piece to its new position, updates board
            piece.x_pos = to_x
            piece.y_pos = to_y
            self.update
            return true # move is complete
    
        elsif move_type == "jump"
            loop do # runs until all jump moves have been exhausted
                # remembers the starting position of the piece
                from_x = piece.x_pos
                from_y = piece.y_pos
    
                # set the piece to its new position
                piece.x_pos = to_x
                piece.y_pos = to_y
    
                # finds captured piece and removes it from the piece.all array - ruby will garbage collect
                Piece.all.delete(Piece.all.find{|p| p.x_pos == (from_x + to_x)/2 && p.y_pos == (from_y + to_y)/2})
                
                # updates board
                self.update
                self.display
                puts "😳Woah, you captured a piece! 👏"
                sleep(1)
    
                # recalculates posisble jump moves and checks if there are any left
                if piece.jump_moves.empty?
                    return true # move is complete
                else
                    loop do # runs until the user provides a valid jump move destination
                        puts "🤔Please provide the coordinates of your next jump."
                        jump_input = gets.chomp.upcase
    
                        if /^[A-H][1-8]$/.match(jump_input) # the user has provided a coordinate in correct format
                            to_pos = jump_input.split("") # splits input string into an array [x,y]
                            to_pos[0] = to_pos[0].ord - 65 # converts letter x-coord to number
                            to_pos[1] = to_pos[1].to_i - 1 # converts 1-indexed user input to 0-indexed internal coords   
                            if piece.jump_moves.include?(to_pos) # if the user input coordinate is indeed a jump move
                                # parses destination coordinate array into individual x and y values
                                to_x = to_pos[0]
                                to_y = to_pos[1]
    
                                break # exits into main loop to execute another jump move
                            else # if the user input coordinate is not a jump move
                                puts "😢You must jump over an opponent piece."
                            end
                        else # the user has not provided a coordinate in wrong format
                            puts "😢That is not a valid coordinate. Examples: 'A2', 'g5'"
                        end
                    end
                end
            end
        end
    end

    def game_over
        if (Piece.all.none?{|p| p.team == "r"})
            winner = self.l_player
            self.l_player.win_count +=1
        else
            winner = self.r_player
            self.r_player.win_count +=1
        end
        # WIN SCREEN
        system("clear") || system("cls")
        self.display
        l_player.save
        r_player.save
        self.destroy
        sleep (0.25)
        puts "\n"
        puts "🎊🥳🎉CONGRAGULATIONS, #{winner.name}! YOU WON!!!!🎉🥳🎊"
        puts "🔥✨💯Your score is now #{winner.win_count}💯✨🔥"
        puts "\n"

        10.times do
            print "👏👍👌👏👍👌👏👍👌👏👍👌👏👍👌👏👍👌\r"
            sleep(0.25)
            print "👍👌👏👍👌👏👍👌👏👍👌👏👍👌👏👍👌👏\r"
            sleep(0.25)
            print "👌👏👍👌👏👍👌👏👍👌👏👍👌👏👍👌👏👍\r"
            sleep(0.25)
        end

        $prompt.keypress("\n🚪🚶Press any key to exit....")
        
    end

end