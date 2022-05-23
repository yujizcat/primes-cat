require "prime"

class Player
  def initialize(name, is_ai)
    @name = name
    @player_id = rand(1001..9999)
    @cards = []
    @original_cards = []
    @level = 0
    @points = 0
    @powers = 0
    @current_history = []
    @is_ai = is_ai
    @range = [determine_level[0], determine_level[1]]
    @init_num_cards = determine_level[2]
    @default_primes = Prime.each(@range[1]).to_a.select { |x| x >= @range[0] }.map { |x| x }
  end

  def reset_player
    @cards = []
    @original_cards = []
    @current_history = []
    @range = [determine_level[0], determine_level[1]]
    @init_num_cards = determine_level[2]
    @default_primes = Prime.each(@range[1]).to_a.select { |x| x >= @range[0] }.map { |x| x }
  end

  def get_id
    return @player_id
  end

  def get_name
    return @name
  end

  def get_level
    return @level
  end

  def get_level_name
    case @level
    when 0
      "小白"
    when 1
      "青铜☆"
    when 2
      "青铜☆☆"
    when 3
      "青铜☆☆☆"
    when 4
      "青铜★"
    when 5
      "白银☆"
    when 6
      "白银☆☆"
    when 7
      "白银☆☆☆"
    when 8
      "白银★"
    when 9
      "黄金☆"
    when 10
      "黄金☆☆"
    when 11
      "黄金☆☆☆"
    when 12
      "黄金★"
    when 13
      "铂金☆"
    when 14
      "铂金☆☆"
    when 15
      "铂金☆☆☆"
    when 16
      "铂金★"
    when 17
      "钻石☆"
    when 18
      "钻石☆☆"
    when 19
      "钻石☆☆☆"
    when 20
      "钻石★"
    when 21
      "星耀☆"
    when 22
      "星耀☆☆"
    when 23
      "星耀☆☆☆"
    when 24
      "星耀★"
    when 25
      "黄金王者"
    when 26
      "铂金王者"
    when 27
      "钻石王者"
    when 28
      "星耀王者"
    when 29
      "传奇王者"
    when 30
      "创世神"
    else
      return "游客"
    end
  end

  def determine_level
    # Set up player's default number of cards, range by level
    each_max = [50, 100, 200, 500, 1000, 2000, 5000, 10000]
    num_cards = if @level.odd? then 3 else 4 end
    case @level
    when 0
      [0, 50, 3]
    when 1..28
      level_index = (@level - 1) / 4
      [if @level % 4 <= 2 && @level % 4 != 0 then 0 else each_max[level_index] end, each_max[level_index + 1], num_cards]
    when 29
      [10000, 100000, 5]
    when 30
      [0, 1000000, 5]
    else
      [0, 50, 3]
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

  def change_level(level)
    @level = level
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
