require_relative "primes_controller"
require_relative "primes_ai"
require_relative "view"

class Router
  def initialize(players)
    @all_players = players
    @primes_game = PrimesGameController.new(@all_players)
    @primes_ai = PrimesGameAI.new(@primes_game)
    @primes_view = PrimesView.new(@primes_game)
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

    #----TEST BEFORE SETTING----
    puts "Welcome #{@all_players[0].get_name}. Please Enter your level: "
    my_level = gets.chomp
    #puts "Enter the rival's level"
    #rival_level = gets.chomp
    @all_players[0].change_level(my_level.to_i)
    @all_players[0].reset_player
    #@all_players[1].change_level(rival_level.to_i)
    #@all_players[1].reset_player
    #---------------------------

    @all_players.each do |player|
      @primes_game.set_up(player)
      player.append_to_history
    end

    @primes_view.display_welcome
    @current_run = true
    pause

    start_time = Time.now

    while @current_run == true
      system "clear"

      p "ppppp"
      p @primes_ai.num_priority(87)
      gets.chomp

      # puts "Uniqueness #{@primes_game.get_current_player.get_uniqueness}, rate: #{@primes_game.get_current_player.get_uniqueness_rate(@primes_game.get_current_round)}%"
      @primes_game.reset_current_possibles
      @primes_game.auto_reduce_fraction(@primes_game.get_current_player.get_cards)
      @primes_game.auto_reduce_fraction(@primes_game.get_current_player.get_cards)
      @primes_game.calculate_current_possibles
      # @primes_game.display_current_possibles
      puts ""

      # Main display process before action
      display_process

      unless @primes_game.get_current_player.is_ai?
        # Start normal process
        main_process_add_reduce_display_append
      else
        # Start the AI process
        # Collect all possible first then test
        @primes_ai.test_collections(@primes_ai.collect_all_actions(@primes_game.get_current_player.get_cards, false))
        @primes_ai.reset_ai_actions
        @primes_game.auto_reduce_fraction(@primes_game.get_current_player.get_cards)
        @primes_game.get_current_player.get_cards
      end

      # Main display process after action
      display_process

      pause

      # Append history for every round
      @primes_game.get_current_player.append_to_history

      # Check game over
      if @primes_game.game_over? || @primes_game.get_current_player.get_cards.size <= 1
        @primes_game.game_over
        game_over(start_time, "Win")

        # game_over(start_time, "Lose") if @primes_game.get_current_player.get_cards.size >= @primes_game.get_current_player.get_original_card.size + 3
        #game_over(start_time, "Lose") if @primes_game.get_current_player.get_powers < 1
      end

      # Finishing this round
      @primes_game.finished_current_round
    end
  end

  def display_process
    system "clear"

    # Beginning Display
    @primes_view.display_top
    if @all_players.size > 1
      # Get another player's card
      @primes_view.display_cards("rival")
    end

    @primes_view.display_space

    # Display action only after action available
    @primes_view.display_actions(@primes_game.get_current_action)

    @primes_view.display_cards("me")
    @primes_view.display_bottom
  end

  def main_process_add_reduce_display_append
    valid_prompt = @primes_game.prompt_check(false, "")
    # p "valid_prompt #{valid_prompt}"
    # pause
    if valid_prompt != false
      @primes_game.prompt_confirmed(valid_prompt[1], valid_prompt[0])
      @primes_game.auto_reduce_fraction(@primes_game.get_current_player.get_cards)
      @primes_game.get_current_player.get_cards
    end
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
    puts "Original cards: #{@primes_game.get_current_player.get_original_card}"
    display_history
    puts "Rounds took: #{@primes_game.get_current_round}"
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
