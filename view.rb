require_relative "primes_controller"

class View
  def initialize
    @running = true
    @inputing = false
    @current_run = false
    @current_player = 1
    @round = 1
    @game_id = 0
    @primes_game = PrimesGameController.new
    @original = []
    @game_points = 0
  end

  def pause
    puts "Press Enter to continute"
    gets.chomp
  end

  def run
    @primes_game.set_up

    puts "----------"
    @game_id = @primes_game.get_player_id
    @current_run = true

    # -------Test only--------
    # @primes_game.change_cards(@game_id, [2, 3, 5])
    # ------------------------

    @original = @primes_game.get_player_cards(@current_player).clone

    # pause
    while @current_run == true
      system "clear"

      # ------------Test score-------------
      # osum = 100
      # rnd = 20
      # p (osum ** 2) / (rnd + 1 + osum / 10)
      # -----------------------------------

      # p "Lucky Number: #{@primes_game.get_lucky_number}"
      puts "---------------Round #{@round}---------------"
      puts ""
      puts "---------------Player #{@current_player}---------------"
      # puts "Points: #{@primes_game.get_player_points(@current_player)}"
      p @primes_game.get_player_cards(@current_player)
      p "Average: #{@primes_game.get_player_cards_average(@current_player)}"
      puts ""

      win if @primes_game.get_player_cards(@current_player).size <= 1

      @primes_game.prompt_add(@current_player)
      @primes_game.auto_reduce_fraction(@current_player)
      @primes_game.get_player_cards(@current_player)

      @round += 1
      @primes_game.auto_reduce_fraction(@game_id)
    end
  end

  def game_points_calculate
    score = (@original.sum ** 2) / (@round + @original.sum / 10)
    return 1 if score < 1
    return score
  end

  def win
    system "clear"
    puts "You Win!"
    puts "Original cards: #{@original}"
    puts "Rounds took: #{@round - 1}"
    puts "Your score: #{game_points_calculate}"
    exit
  end
end
