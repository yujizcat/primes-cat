require_relative "primes_controller"

class Router
  def initialize(range, cards)
    @id = 1
    @player = Player.new("player#{@id}", @id)
    @rival = Player.new("Rival", @id + 1)
    @all_players = [0, @player, @rival]
    @primes_game = PrimesGameController.new(@player, range, cards)
    @running = true
    @inputing = false
    @current_run = false
    @current_player = @player
    @round = 1
    @original = []
    @game_points = 0
  end

  def pause
    puts "Press Enter to continute"
    gets.chomp
  end

  def run
    @primes_game.set_up(@player)
    @primes_game.set_up(@rival)

    puts "----------"
    @current_run = true
    pause

    # -------Test only--------
    # @primes_game.change_cards([2, 3, 5])
    # ------------------------

    @original = @player.get_cards.clone

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
      puts "---------------Round #{@round}---------------"
      puts ""
      puts "---------------Player #{@current_player.get_id}---------------"
      puts ""
      puts "Uniqueness #{@current_player.get_uniqueness}, rate: #{@current_player.get_uniqueness_rate(@round)}%"
      @primes_game.reset_current_possibles
      @primes_game.auto_reduce_fraction
      p "#{@current_player.get_cards}"
      puts ""
      p "<#{@current_player.get_cards_average}>"
      p "Powers: #{@current_player.get_powers}"
      @primes_game.calculate_current_possibles
      @primes_game.get_current_possibles
      puts ""

      # Get another player's card
      if @current_player == @player
        p @rival.get_cards
      else
        p @player.get_cards
      end

      win(start_time) if @current_player.get_cards.size <= 1
      lose(start_time, "Exceed Cards") if @current_player.get_cards.size >= @original.size + 3
      lose(start_time, "No Powers") if @current_player.get_powers < 1

      @primes_game.prompt_add
      @primes_game.auto_reduce_fraction
      @current_player.get_cards

      @round += 1
      @primes_game.auto_reduce_fraction
      @current_player.append_to_history

      finished_current_round
    end
  end

  def game_points_calculate(total_time)
    score = (((@original.sum ** Math.cbrt(@original.sum.size) ** 0.9) / (@round * 4 + total_time / 4)) ** 1.5).to_i
    return 1 if score < 1
    return score
  end

  def win(start_time)
    end_time = Time.now
    total_time = end_time - start_time
    system "clear"
    puts "---------------------------------------"
    puts "You Win!"
    puts "Original cards: #{@original}"
    display_history
    puts "Rounds took: #{@round - 1}"
    puts "Time took: #{total_time.round(2)}s"
    puts "Your score: #{game_points_calculate(total_time).to_i}"
    puts "---------------------------------------"
    exit
  end

  def lose(start_time, reason)
    end_time = Time.now
    total_time = end_time - start_time
    system "clear"
    puts "---------------------------------------"
    puts "You Lose!"
    puts reason
    puts "Original cards: #{@original}"
    display_history
    puts "Rounds took: #{@round - 1}"
    puts "Time took: #{total_time.round(2)}s"
    puts "Your score: 0"
    puts "---------------------------------------"
    exit
  end

  def display_history
    @current_player.get_current_history.each_with_index do |h, i|
      puts "Step #{i} #{h}"
    end
  end

  def finished_current_round
    @round += 1
    if @current_player == @player
      @current_player = @rival
    else
      @current_player = @player
    end
    @primes_game.set_player_as_current(@current_player)
  end
end
