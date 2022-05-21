require_relative "primes_controller"

class PrimesGameAI < PrimesGameController
  def initialize(game)
    @game = game
    @current_actions_collect = []
    @all_next_possibles = []
  end

  def collect_all_actions
    puts ""
    p "Collecting all possible actions..."
    actions_sum_collect = []
    @game.reset_current_possibles
    @game.calculate_current_possibles

    @game.get_current_possibles.each do |poss|
      @current_actions_collect << "#{poss[0]} #{poss[1]}"
      actions_sum_collect << poss[0] + poss[1]
    end

    @game.get_current_player.get_cards.each do |card|
      @current_actions_collect << "a #{card}"
      actions_sum_collect << card + @game.get_current_player.get_cards_average
    end

    if @game.get_next_player.get_cards.size > 2
      @game.get_next_player.get_cards.each do |card|
        @current_actions_collect << "s #{card}"
        actions_sum_collect << card + @game.get_next_player.get_cards_average
      end
    end

    return actions_sum_collect
  end

  def test_collections(sum_collections)
    def is_integer?(i)
      i.to_i.to_s == i
    end

    p @current_actions_collect
    p sum_collections
    @current_actions_collect.each do |poss|
      # Reset current and next card each loop
      current_cards = @game.get_current_player.get_cards.clone
      # next_cards = @game.get_next_player.get_cards.clone

      # p poss

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
    p @all_next_possibles
    begin_action
    return @all_next_possibles
  end

  def begin_action
    p "begin action"
    random_action
  end

  def random_action
    def is_integer?(i)
      i.to_i.to_s == i
    end

    input = @current_actions_collect.sample
    p @game.get_current_player.get_cards
    p @game.get_next_player.get_cards
    if is_integer?(input[0])
      input = input.split(" ").to_a.map { |m| m.to_i }
    else
      input = input.split(" ")
      input[1] = input[1].to_i
    end
    p input
    @game.prompt_add(true, input)
  end

  def get_shortest
    shortest = @all_next_possibles.sort_by { |x| x.size }[0].size
    p shortest
  end

  def reset_ai_actions
    @current_actions_collect = []
    @all_next_possibles = []
  end
end
