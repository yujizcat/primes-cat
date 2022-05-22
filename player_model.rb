require "prime"

class Player
  def initialize(name, is_ai, level)
    @name = name
    @player_id = rand(1001..9999)
    @cards = []
    @original_cards = []
    @level = level
    @points = 0
    @powers = 0
    @average_round = 0
    @current_history = []
    @is_ai = is_ai
    # p determine_level
    @min_range = determine_level[0]
    @max_range = determine_level[1]
    @init_num_cards = determine_level[2]
    @default_primes = Prime.each(@max_range).to_a.select { |x| x >= @min_range }.map { |x| x }
  end

  def get_id
    return @player_id
  end

  def get_name
    return @name
  end

  def determine_level
    # Set up player's default number of cards, range by level
    each_max = [50, 100, 200, 500, 1000, 2000, 5000, 10000]
    num_cards = if @level.odd? then 3 else 4 end
    case @level
    when 0
      [0, 50, 0]
    else
      level_index = (@level - 1) / 4
      [if @level % 4 <= 2 && @level % 4 != 0 then 0 else each_max[level_index] end, each_max[level_index + 1], num_cards]
    end
  end

  def get_init_primes
    return @default_primes
  end

  def get_init_num_cards
    return @init_num_cards
  end

  def init_cards(card)
    @cards << card
  end

  def set_original_card
    @original_cards = @cards.clone
  end

  def get_original_card
    @original_cards
  end

  def get_cards
    sort_cards
    return @cards
  end

  def get_cards_average
    if @cards.size > 0
      return @cards.sum / @cards.size
    else
      return 0
    end
  end

  def change_cards(new_cards)
    @cards = new_cards
  end

  def get_points
    return @cards.sum
  end

  def sort_cards
    @cards.sort!
  end

  def append_to_history
    @current_history << @cards.sort
  end

  def get_current_history
    return @current_history
  end

  def get_uniqueness
    return @current_history.uniq.size
  end

  def get_uniqueness_rate(round)
    return ((@current_history.uniq.size * 1.0 / round).round(2) * 100).to_i
  end

  def set_init_powers
    @powers = (get_cards[-1] / 10) + get_cards.size
    return @powers
  end

  def get_powers
    return @powers
  end

  def reduce_powers
    @powers -= 1
    return @powers
  end

  def clean_powers
    @powers = 0
  end

  def is_ai?
    @is_ai
  end
end
