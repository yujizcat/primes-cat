require_relative "player_model"
require_relative "router"
require "prime"
require "set"

class PrimesGameController
  def initialize(all_players, range, cards)
    @min_init = range[0]
    @max_init = range[1]
    @default_primes = Prime.each(@max_init).to_a
    @default_primes = @default_primes.select { |x| x >= @min_init }.map { |x| x }
    @num_cards = cards
    @id = 1
    @all_players = all_players
    @player = @all_players[0]
    @current_player = @player
    @round = 1
    @lucky_number = rand(2..99)
    @current_possibles = []
  end

  def set_up(player)
    [*1..@num_cards].each do |i|
      player.init_cards(@default_primes.delete(@default_primes.sample))
    end
    player.sort_cards
    player.set_init_powers
    player.set_original_card
  end

  def set_player_as_current(player)
    @current_player = player
  end

  def get_current_player
    @current_player
  end

  def get_first_player
    @all_players[0]
  end

  def get_lucky_number
    return @lucky_number
  end

  def get_current_round
    @round
  end

  def prompt
    puts ""
    puts "Which two numbers you want to select to add their sum to your last array"
    puts "For example, type: #{@current_player.get_cards[0]}  #{@current_player.get_cards[1]}" if @current_player.get_cards.size > 1
    puts "Or you can use one power to add average #{@current_player.get_cards_average} directly to any number."
    puts "For example, type: a #{@current_player.get_cards[0]}"
    puts "Or you can use one power to take rival's card to add to the sum to your greatest card."
    puts "For example, type: s (river's card)"
  end

  def prompt_add
    running = true
    while running
      prompt
      input = input_filter()
      puts ""
      action = input[0]
      value = input[1]
      if input[0].instance_of?(String)
        if action == "a"
          # add average into one of my card
          add_avg = add_average_card(value)
          if add_avg == true
            running = false
            return 1
          end
        else
          # take next card
          take_card = check_next_card(value)
          if take_card == true
            running = false
            return 1
          end
        end
      else

        # add card my self in a new card
        self_add = check_self_card(input)
        if self_add == true
          add_self_card(input[0], input[1])
          running = false
          return 1
        else
          puts "Invalid add, please re-try"
        end
      end
    end
  end

  def change_cards(new_cards)
    @current_player.change_cards(new_cards)
  end

  def check_self_card(index)
    return [-1, -1] if index == false
    if index[0] != "a"
      # Add number directly
      player_card = @current_player.get_cards
      p index.map { |x| player_card.include?(x) }.all? { |t| t == true }
      return index.map { |x| player_card.include?(x) }.all? { |t| t == true }
    end
  end

  def add_self_card(index1, index2)
    return "Invalid" if index1 == -1 || index2 == -1
    player_card = @current_player.get_cards
    # new_value = player_card[index1] + player_card[index2]
    new_value = index1 + index2
    player_card.flatten!
    player_card.push(new_value.to_i)
    # p player_card
    auto_reduce_fraction()
    return player_card
  end

  def add_average_card(current_card)
    player_card = @current_player.get_cards
    current_avg = @current_player.get_cards_average
    # p player_card
    # p current_avg
    # p current_card
    if player_card.include?(current_card)
      # new_value = player_card[player_card.index(current_card)] + current_avg
      player_card[player_card.index(current_card)] += current_avg
      # p player_card
      @current_player.change_cards(player_card)
      @current_player.reduce_powers
      return true
    else
      p "Error, you don't have #{current_card} in your cards!"
      return false
    end
  end

  def check_next_card(current_card)
    player_card = @current_player.get_cards
    if @all_players.size > 1
      next_player_card = get_next_player.get_cards
    else
      p "Error, only one player"
      return false
    end
    if next_player_card.include?(current_card)
      # Only allow if other person'card size > 2
      if next_player_card.size > 2
        @current_player.get_cards[-1] += current_card
        next_player_card.delete(current_card)
        @current_player.reduce_powers
        return true
      else
        p "Error, the other person must have more than 2 cards!"
        return false
      end
    else
      p "Error, the rival does not have #{current_card}"
      return false
    end
  end

  def auto_reduce_fraction
    gcd_found = false
    common_number = false
    change_index = [-1, -1]
    player_card = @current_player.get_cards
    player_card.each_with_index do |x, i|
      player_card.each_with_index do |y, j|
        break if gcd_found == true
        if x != y
          unless (x == 1) || (y == 1)
            # p "#{x}, #{y}"
            # puts "#{x},#{i}-----#{y},#{j}"

            if x.gcd(y) != 1
              # puts "gcd #{x.gcd(y)}"
              # change_index = [i, j]
              # p change_index
              player_card[i] /= x.gcd(y)
              player_card[j] /= x.gcd(y)
              gcd_found = true
            end
          end
        else
          if i != j
            change_index = [i, j]
            common_number = true
            gcd_found = true
          end
        end
      end
    end
    if common_number
      player_card.delete_at(change_index[1])
      player_card.delete_at(change_index[0])
    end
    player_card.delete(1) if player_card.include?(1)
    player_card.sort!
    return player_card
  end

  def input_filter
    def is_integer?(i)
      i.to_i.to_s == i
    end

    def uniq?(i)
      i.length == i.uniq.length
    end

    add_avg = 0
    is_add_avg = false

    valid = false
    while true
      input = gets.chomp
      if input.split(" ").length == 2
        if input.split(" ")[0] == "a" || input.split(" ")[0] == "s"
          if is_integer?(input.split(" ")[1])
            add_avg = input.split(" ")[1].to_i
            is_add_avg = true
            valid = true
          else
            return false
          end
        else
          input.split(" ").each do |i|
            unless is_integer?(i)
              valid = false
              break
            end
            valid = true
          end
        end
      end
      if valid == true
        break if is_add_avg
        return false unless uniq?(input.split(" ").to_a)
        break
      else
        puts "invalid"
      end
    end
    if is_add_avg
      return [input[0], add_avg]
    else
      return input.split(" ").to_a.map { |m| m.to_i }
    end
  end

  def get_current_possibles
    puts ""
    puts "----All possibles----"
    @current_possibles.each do |poss|
      sum = poss[0] + poss[1]
      puts "#{poss[0]} + #{poss[1]} = #{sum}"
    end
  end

  def reset_current_possibles
    @current_possibles = []
  end

  def calculate_current_possibles
    player_card = @current_player.get_cards
    player_card.each_with_index do |x, i|
      player_card.each_with_index do |y, j|
        if i != j
          unless @current_possibles.include?([y, x])
            @current_possibles.push([x, y])
          end
        end
      end
    end
  end

  def get_next_player
    next_player_index = @all_players.index(@current_player) + 1
    if next_player_index < @all_players.size
      return @all_players[next_player_index]
    else
      return @all_players[0]
    end
  end

  def finished_current_round
    # Get the current round of player index
    current_round = @all_players.index(@current_player)

    if @current_player == @all_players[-1]
      # If the player is last, go to the new round and set current 0
      @current_player = @all_players[0]
      @round += 1
    else
      # If the player is not last, keep going
      @current_player = @all_players[current_round + 1]
    end
    set_player_as_current(@current_player)
  end
end
