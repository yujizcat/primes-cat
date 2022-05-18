require_relative "primes_controller"

class Router
  def initialize(range, cards)
    @running = true
    @inputing = false
    @current_run = false
    @current_player = 1
    @round = 1
    @game_id = 0
    @primes_game = PrimesGameController.new(range, cards)
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
    pause

    # -------Test only--------
    # @primes_game.change_cards(@game_id, [2, 3, 5])
    # ------------------------

    @original = @primes_game.get_player_cards(@current_player).clone

    # pause
    start_time = Time.now
    @primes_game.append_to_history
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
      puts "---------------Player #{@current_player}---------------"
      puts ""
      puts "Uniqueness #{@primes_game.get_uniqueness}"
      # puts "Points: #{@primes_game.get_player_points(@current_player)}"
      @primes_game.auto_reduce_fraction(@current_player)
      p "#{@primes_game.get_player_cards(@current_player)}"
      puts ""
      p "<#{@primes_game.get_player_cards_average(@current_player)}>"
      p "Powers: #{@primes_game.get_powers}"
      puts ""

      win(start_time) if @primes_game.get_player_cards(@current_player).size <= 1
      lose(start_time, "Exceed Cards") if @primes_game.get_player_cards(@current_player).size >= @original.size + 3
      lose(start_time, "No Powers") if @primes_game.get_powers < 1

      @primes_game.prompt_add(@current_player)
      @primes_game.auto_reduce_fraction(@current_player)
      @primes_game.get_player_cards(@current_player)

      @round += 1
      @primes_game.auto_reduce_fraction(@game_id)
      @primes_game.append_to_history
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
    @primes_game.get_current_history.each_with_index do |h, i|
      puts "Step #{i} #{h}"
    end
  end
end
