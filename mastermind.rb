colors = ["red", "green", "blue", "yellow", "orange", "purple", "pink"]

class Computer
    attr_reader :secret_code

    def initialize(role, possible_colors)
        @role = role
        @colors = possible_colors
    end

    def make_code
        @secret_code = []
        for i in (0...4) do
            @secret_code.push(@colors.sample)
        end
    end

    def break_code(matches=[])
        if matches == []
            make_code
        else
            prev_code = @secret_code.map(&:clone)
            part_matches = []
            matches.each_with_index do |match, index|
                if match == "M"
                    @secret_code[index] = prev_code[index]
                elsif match == "P"
                    part_matches.push(prev_code[index])
                else
                    @secret_code[index] = @colors.sample
                end
            end

            matches.each_with_index do |match, index|
                if match == "P"
                    @secret_code[index] = part_matches.sample
                end
            end
        end
        puts "The computer guesses:"
        puts "#{@secret_code}"
    end
end

class Game
    attr_accessor :user_code

    def initialize(computer, possible_colors, num_turns=12)
        @cpu = computer
        @num_turns = num_turns
        @colors = possible_colors
        @results = []
        @player_role = 0
        puts "Welcome to Mastermind!"
        puts "In this game you can either make a secret code for the computer to guess or you can guess the computer's secret code."
        while @player_role != 1 && @player_role != 2 do
            puts "Press 1 to be the Code Maker"
            puts "Press 2 to be the Code Breaker"
            @player_role = gets.chomp.to_i
        end
    end

    private

    def get_user_code
        @user_code = []
        puts "Enter a code of 4 colors (press enter after each color):"
        for i in (0...4) do
            while not @colors.include?(@user_code[i]) do
                @user_code[i] = gets.chomp.downcase
                if not @colors.include?(@user_code[i])
                    print "Not a color in the list. Try again: "
                end
            end
        end
        puts "Here is your code:"
        puts "#{@user_code}"
    end

    def compare_guess(secret_code, guess_code)
        secret = secret_code.map(&:clone)
        @results = ["?", "?", "?", "?"]
        exact_matches = 0
        partial_matches = 0
        for i in (0...4) do
            if guess_code[i] == secret_code[i]
                secret[i] = "M"
                @results[i] = ("M")
                exact_matches += 1
            end
        end

        for i in (0...4) do
            if secret.include?(guess_code[i]) && secret[i] != "M"
                @results[i] = ("P")
                partial_matches += 1
            end
        end
        puts "#{@results}"
        puts "Exact Matches (M): #{exact_matches}"
        puts "Partial Matches (P): #{partial_matches}"
    end

    def code_maker
        puts "Create a code using 4 of the following colors."
        puts "#{@colors}"
        get_user_code
        while @num_turns > 0
            puts "The computer has #{@num_turns} guesses remaining"
            @cpu.break_code(@results)
            compare_guess(@user_code, @cpu.secret_code)
            if @user_code == @cpu.secret_code
                puts "Game 0ver! The computer guessed the code!"
                break
            end
            
            print "press [enter] to see the computer's next guess."
            gets.chomp
            puts "-------------------------"
            @num_turns -= 1
        end
    end

    def code_breaker
        @cpu.make_code
        puts "Guess the computer's code from these possible colors:"
        puts "#{@colors}"

       while @num_turns > 0
            puts "You have #{@num_turns} guesses remaining."
            results = Array.new(4)
            get_user_code
            compare_guess(@cpu.secret_code, @user_code)
            if @user_code == @cpu.secret_code
                puts "You guessed the code!"
                break
            end

            puts "-------------------------"
            @num_turns -=1
       end
    end

    public

    def play
       if @player_role == 1
            code_maker
       else
            code_breaker
       end
    end
end

new_cpu = Computer.new('maker', colors)
new_game = Game.new(new_cpu, colors, 12)
new_game.play
