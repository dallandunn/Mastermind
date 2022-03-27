colors = ["red", "green", "blue", "yellow", "orange", "purple", "pink"]

class Computer
    attr_reader :secret_code

    def initialize(role, possible_colors)
        @role = role
        @colors = possible_colors
    end

    def code_maker
        @secret_code = []
        for i in (0...4) do
            @secret_code.push(@colors.sample)
        end
    end
end

class Game
    attr_accessor :user_code

    def initialize(computer, possible_colors, num_turns=12)
        @cpu = computer
        @num_turns = num_turns
        @colors = possible_colors
    end

    private

    def get_user_code
        @user_code = []
        puts "Enter a code of 4 colors (press enter after each color):"
        for i in (0...4) do
            while not @colors.include?(@user_code[i]) do
                @user_code[i] = gets.chomp
                if not @colors.include?(@user_code[i])
                    print "Not a color in the list. Try again: "
                end
            end
        end
        puts "Here is your code:"
        puts "#{@user_code}"
    end

    def compare_guess(secret_code)
        results = []
        exact_matches = 0
        partial_matches = 0
        for i in (0...4) do
            if @user_code[i] == secret_code[i]
                results.push("M")
                exact_matches += 1
            elsif secret_code.include?(@user_code[i])
                results.push("P")
                partial_matches += 1
            else
                results.push("X")
            end
        end
        puts "#{results}"
        puts "Exact Matches: #{exact_matches}"
        puts "Partial Matches: #{partial_matches}"
    end

    public

    def play
        @cpu.code_maker
        puts "Guess the computer's code from these possible colors:"
        puts "#{@colors}"

       while @num_turns > 0
            puts "You have #{@num_turns} guesses remaining."
            results = Array.new(4)
            get_user_code
            compare_guess(@cpu.secret_code)
            if @user_code == @cpu.secret_code
                break
            end

            puts "-------------------------"
            @num_turns -=1
       end
    end
end

new_cpu = Computer.new('maker', colors)
new_game = Game.new(new_cpu, colors, 12)
new_game.play
