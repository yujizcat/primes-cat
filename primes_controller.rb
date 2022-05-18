require "prime"
require_relative "player_model"
require "set"

class PrimesGameController
  def initialize(range, cards)
    @max_init = range
    @default_primes = Prime.each(@max_init).to_a
    @num_cards = cards
    @id = 1
    @players = Player.new("player#{@id}", @id)
    @lucky_number = rand(2..99)
    # all_players("init")
  end

  def set_up
    [*1..@num_cards].each do |i|
      # @players.init_cards(@default_primes.delete(@default_primes.sample))

      if i == @num_cards + 1 # not use
        duplicate = true
        while duplicate
          card = rand(2..@max_init)
          unless @players.get_cards.include?(card)
            @players.init_cards(card)
            duplicate = false
            break
          end
        end
      else
        @players.init_cards(@default_primes.delete(@default_primes.sample))
      end
    end
    @players.sort_cards
    @players.set_init_powers
  end

  def get_lucky_number
    return @lucky_number
  end

  def get_player_id
    return @players.get_id
  end

  def get_player_cards(player_id)
    @players.get_cards
  end

  def get_player_cards_average(player_id)
    @players.get_cards_average
  end

  def get_player_points(player_id)
    @players.get_points
  end

  def all_players(action)
    case action

    when "get"
      p @players.get_cards
    end
  end

  def prompt_add(player_id)
    running = true
    while running
      puts ""
      puts "Which two numbers you want to select to add their sum to your last array"
      puts "For example, type: #{get_player_cards(player_id)[0]}  #{get_player_cards(player_id)[1]}" if get_player_cards(player_id).size > 1
      puts "Or you can use one power to add average #{get_player_cards_average(player_id)} directly to any number."
      puts "For example, type: a #{get_player_cards(player_id)[0]}"
      input = input_filter()
      puts ""

      if input.class == Integer
        # add average into one of my card
        add_avg = add_average_card(player_id, input)
        if add_avg == true
          running = false
          return 1
        end
      else
        # add card my self in a new card
        self_add = check_self_card(player_id, input)
        if self_add == true
          add_self_card(player_id, input[0], input[1])
          running = false
          return 1
        else
          puts "Invalid add, please re-try"
        end
      end
    end
  end

  def change_cards(player_id, new_cards)
    @players.change_cards(new_cards)
  end

  def select_self_card(player_id)
    player_card = @players[player_id].get_cards
  end

  def check_self_card(player_id, index)
    return [-1, -1] if index == false
    if index[0] != "a"
      #Add number directly
      player_card = @players.get_cards
      p index.map { |x| player_card.include?(x) }.all? { |t| t == true }
      return index.map { |x| player_card.include?(x) }.all? { |t| t == true }
    end
  end

  def add_self_card(player_id, index1, index2)
    return "Invalid" if index1 == -1 || index2 == -1
    player_card = @players.get_cards
    # new_value = player_card[index1] + player_card[index2]
    new_value = index1 + index2
    player_card.flatten!
    player_card.push(new_value.to_i)
    p player_card
    auto_reduce_fraction(player_id)
    return player_card
  end

  def add_average_card(player_id, current_card)
    player_card = @players.get_cards
    current_avg = get_player_cards_average(player_id)
    # p player_card
    # p current_avg
    # p current_card
    if player_card.include?(current_card)
      #new_value = player_card[player_card.index(current_card)] + current_avg
      player_card[player_card.index(current_card)] += current_avg
      p player_card
      change_cards(player_id, player_card)
      @players.reduce_powers
      return true
    else
      p "Error, you don't have #{current_card} in your cards!"
      return false
    end
  end

  def auto_reduce_fraction(player_id)
    gcd_found = false
    common_number = false
    change_index = [-1, -1]
    player_card = @players.get_cards
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
            # p player_card
            # player_card.delete_at(i)

            gcd_found = true
          end
        end
      end
    end
    if common_number
      # p change_index.sort!
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
        if input.split(" ")[0] == "a"
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
      return add_avg
    else
      return input.split(" ").to_a.map { |m| m.to_i }
    end
  end

  def validate_next_card(player_id, my_select)
    def is_integer?(i)
      i.to_i.to_s == i
    end

    return false unless is_integer?(my_select)
    selected = my_select.strip.to_i
    # p get_player_cards(player_id)
    # p get_player_cards(player_id + 1)
    unless get_player_cards(player_id + 1).include?(selected)
      puts "The selected number is not exist in next's person's card"
      return false
    end
    return selected
  end

  def append_to_history
    @players.append_to_history
  end

  def get_current_history
    @players.get_current_history
  end

  def get_uniqueness
    @players.get_uniqueness
  end

  def get_powers
    @players.get_powers
  end
end
