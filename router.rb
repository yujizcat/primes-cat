require_relative "primes_controller"

class Router
  def initialize(range, cards)
    @id = 1
    @player = Player.new("player#{@id}", @id)
    @rival = Player.new("Rival", @id + 1)
    @all_players = [@player, @rival]
    # @all_players = [@player]
    @primes_game = PrimesGameController.new(@all_players, range, cards)
    @running = true
    @inputing = false
    @current_run = false
    @round = 1
    @original = []
    @game_points = 0
  end

  def pause
    puts "Press Enter to continute"
    gets.chomp
  end

  def run
    @all_players.each do |player|
      @primes_game.set_up(player)
    end

    puts "----------"
    @current_run = true
    pause

    # -------Test only--------
    # @primes_game.change_cards([2, 3, 5])
    # ------------------------

    # Make a clone of each player's original cards
    # @original = @player.get_cards.clone

    # pause
    start_time = Time.now
    @player.append_to_history
    while @current_run == true
      system "clear"

      # ------------Test score-------------
      # osum = 100
      # olen = 4
      # rnd = 16
      # t = 40
      # p (((osum ** Math.cbrt(olen) ** 0.9) / (rnd * 4 + t / 4)) ** 1.5).to_i
      # exit
      # -----------------------------------

      # p "Lucky Number: #{@primes_game.get_lucky_number}"

      # Get current round and player
      puts "---------------Round #{@primes_game.get_current_round}---------------"
      puts ""
      puts "---------------#{@primes_game.get_current_player.get_name}---------------"
      puts ""
      puts "Uniqueness #{@primes_game.get_current_player.get_uniqueness}, rate: #{@primes_game.get_current_player.get_uniqueness_rate(@primes_game.get_current_round)}%"
      @primes_game.reset_current_possibles
      @primes_game.auto_reduce_fraction
      p "#{@primes_game.get_current_player.get_cards}"
      puts ""
      p "<#{@primes_game.get_current_player.get_cards_average}>"
      p "Powers: #{@primes_game.get_current_player.get_powers}"
      @primes_game.calculate_current_possibles
      @primes_game.get_current_possibles
      puts ""

      # Get another player's card
      if @primes_game.get_current_player == @player
        p @primes_game.get_next_player.get_cards
      else
        p @primes_game.get_first_player.get_cards
      end
      main_process_add_reduce_display_append
      game_over(start_time, "Win") if @primes_game.get_current_player.get_cards.size <= 1
      game_over(start_time, "Lose") if @primes_game.get_current_player.get_cards.size >= @player.get_original_card.size + 3
      game_over(start_time, "Lose") if @primes_game.get_current_player.get_powers < 1

      @primes_game.finished_current_round
    end
  end

  def main_process_add_reduce_display_append
    @primes_game.prompt_add
    @primes_game.auto_reduce_fraction
    @primes_game.get_current_player.get_cards
    @primes_game.get_current_player.append_to_history
  end

  def game_points_calculate(total_time)
    round = @primes_game.get_current_round
    score = (((@original.sum ** Math.cbrt(@original.sum.size) ** 0.9) / (round * 4 + total_time / 4)) ** 1.5).to_i
    return 1 if score < 1
    return score
  end

  def game_over(start_time, ending)
    end_time = Time.now
    total_time = end_time - start_time
    system "clear"
    puts "---------------------------------------"
    puts "#{@primes_game.get_current_player.get_name} #{ending}"
    puts "Original cards: #{@player.get_original_card}"
    display_history
    puts "Rounds took: #{@primes_game.get_current_round - 1}"
    puts "Time took: #{total_time.round(2)}s"
    if ending == "Win"
      puts "Your score: #{game_points_calculate(total_time).to_i}"
    else
      puts "Your score: 0"
    end
    puts "---------------------------------------"
    exit
  end

  def display_history
    @primes_game.get_current_player.get_current_history.each_with_index do |h, i|
      puts "Step #{i} #{h}"
    end
  end
end
