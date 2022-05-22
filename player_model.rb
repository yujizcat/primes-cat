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
    @average_round = 0
    @current_history = []
    @is_ai = is_ai
    # p determine_level
    @min_range = determine_level[0]
    @max_range = determine_level[1]
    @init_num_cards = determine_level[2]
    @default_primes = Prime.each(@max_range).to_a.select { |x| x >= @min_range }.map { |x| x }
  end

  def reset_player
    @cards = []
    @original_cards = []
    @current_history = []
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

  def get_level
    return @level
  end

  def get_level_name
    case @level
    when 0
      "小白"
    when 1
      "初级青铜"
    when 2
      "中级青铜"
    when 3
      "高级青铜"
    when 4
      "特级青铜"
    when 5
      "初级白银"
    when 6
      "中级白银"
    when 7
      "高级白银"
    when 8
      "特级白银"
    when 9
      "初级黄金"
    when 10
      "中级黄金"
    when 11
      "高级黄金"
    when 12
      "特级黄金"
    when 13
      "初级铂金"
    when 14
      "中级铂金"
    when 15
      "高级铂金"
    when 16
      "特级铂金"
    when 17
      "初级钻石"
    when 18
      "中级钻石"
    when 19
      "高级钻石"
    when 20
      "特级钻石"
    when 21
      "初级星耀"
    when 22
      "中级星耀"
    when 23
      "高级星耀"
    when 24
      "特级星耀"
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
