require_relative "primes_controller"

class PrimesGameAI < PrimesGameController
  def initialize(game)
    @game = game
    @current_actions_collect = []
    @all_next_possibles = []
    @percentage_chance = 0
    @ai_input = nil
    @smartness = 100
  end

  def collect_all_actions(card_collect, is_testing)
    puts ""
    p "Collecting all possible actions..."
    actions_sum_collect = []

    @game.reset_current_possibles
    @game.calculate_current_possibles

    @game.get_current_possibles.each do |poss|
      @current_actions_collect << "#{poss[0]} #{poss[1]}"
      actions_sum_collect << poss[0] + poss[1]
    end

    # If no powers, only can self add except only left 2 cards
    if @game.get_current_player.get_powers >= 1 || @game.get_current_player.get_cards.size <= 2
      card_collect.each do |card|
        @current_actions_collect << "a #{card}"
        actions_sum_collect << card + (card_collect.sum / card_collect.size)
      end
      # unless is_testing == true
      if @game.get_next_player.get_cards.size > 2 && @game.get_all_players.size > 1
        @game.get_next_player.get_cards.each do |card|
          @current_actions_collect << "s #{card}"
          actions_sum_collect << card + @game.get_next_player.get_cards_average
        end
      end
      # end
    end

    return actions_sum_collect
  end

  def test_collections(sum_collections)
    def is_integer?(i)
      i.to_i.to_s == i
    end

    # p @current_actions_collect
    # p sum_collections

    @current_actions_collect.each do |poss|
      # Reset current and next card each loop
      current_cards = @game.get_current_player.get_cards.clone

      if is_integer?(poss[0])
        new_temp = poss.split(" ")[0].to_i + poss.split(" ")[1].to_i
        current_cards << new_temp
        @all_next_possibles << current_cards
      elsif poss[0] == "a"
        current_cards[current_cards.index(poss.split(" ")[1].to_i)] += @game.get_current_player.get_cards_average
        @all_next_possibles << current_cards
      elsif poss[0] == "s"
        current_cards[-1] += poss.split(" ")[1].to_i
        @all_next_possibles << current_cards
      else
        return false
      end
    end
    @all_next_possibles.map { |card| @game.auto_reduce_fraction(card) }
    @all_next_possibles.map { |card| @game.auto_reduce_fraction(card) }
    # @all_next_possibles.sort_by! { |x| x.size }
    # p @all_next_possibles

    # avoid_new_primes

    begin_action
    return @all_next_possibles
  end

  def begin_action
    def is_integer?(i)
      i.to_i.to_s == i
    end

    p "begin action"
    p @current_actions_collect
    p @all_next_possibles

    @percentage_chance = rand(1..100)

    is_in_last = check_last_conditions

    if is_in_last == true
    else
      # special_select = minimize_size
      @ai_input = minimize_value
    end

    unless is_in_last
      if @game.get_current_player.get_uniqueness_rate(@game.get_current_round) < 60 || @percentage_chance >= @smartness
        execute_action("random", @ai_input)
      else
        execute_action("special", @ai_input)
      end
    else
      execute_action("last", @ai_input)
    end
  end

  def execute_action(type, value)
    def is_integer?(i)
      i.to_i.to_s == i
    end

    if value == nil || value[0] == nil
      @game.game_over
      return 0
    end

    case type
    when "random"
      p "random select"
      input = @current_actions_collect.sample
    when "special"
      p "special select"
      input = value
    when "last"
      p "in last"
    end
    if is_integer?(input[0])
      input = input.split(" ").to_a.map { |m| m.to_i }
    else
      input = input.split(" ")
      input[1] = input[1].to_i
    end
    p "The action is #{input}"
    valid_prompt = @game.prompt_check(true, input)
    if valid_prompt != false
      @game.prompt_confirmed(valid_prompt[1], valid_prompt[0])
    end
  end

  def minimize_size
    min_size = @all_next_possibles.sort_by { |x| x.size }[0].size if @current_actions_collect.size > 0

    if min_size != 0
      min_size_possibles = @all_next_possibles.select { |a| a.size == min_size }
      value = @current_actions_collect[@all_next_possibles.index(min_size_possibles.sample)]
    else
      value = ""
    end
    return value
  end

  def minimize_value
    min_value = @all_next_possibles.sort_by { |x| x.sum }[0]
    p min_value
    value = @current_actions_collect[@all_next_possibles.index(min_value)]
    p value
    return value
  end

  def avoid_new_primes
    @all_next_possibles.each do |m|
      if m.size > @game.get_current_player.get_cards.size
        new_primes = (m - @game.get_current_player.get_cards)[0]
        if Prime.prime?(new_primes)
          m.delete(new_primes)
        end
      end
    end
  end

  def check_last_conditions
    is_last = false
    if @game.get_current_player.get_cards == [2, 3]
      is_last = true
      @ai_input == "2 3"
    end
    if @game.get_current_player.get_cards == [2, 3, 5]
      is_last = true
      @ai_input == "a 3"
    end
    return is_last
  end

  def reset_ai_actions
    @current_actions_collect = []
    @all_next_possibles = []
    @percentage_chance = 0
    @ai_input = nil
  end
end
