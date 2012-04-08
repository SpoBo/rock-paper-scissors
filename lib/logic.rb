require 'pry'

class GameMechanic

  @@HANDS = {:rock => :scissors, :scissors => :paper, :paper => :rock}

  def self.superior_hand(hand_1, hand_2)
    return false if hand_1 == hand_2

    raise_error_if_unknown_hand(hand_1)
    return hand_1 if @@HANDS[hand_1] == hand_2
    raise_error_if_unknown_hand(hand_2)
    return hand_2 if @@HANDS[hand_2] == hand_1
  end

  # determine who wins from all the players.
  def self.battle(*players)
    return false if players.count <= 1

    winning_player = nil
    players.each do |player|
      if winning_player == nil
        winning_player = player
      else
        result = duel(winning_player, player)
        winning_player = result if result
      end
    end

    # if all hands are equal to the winning hand we should return false.
    return false if players.count { |p| p[:hand] != winning_player[:hand] } == 0

    # if all hands are present we should return false.
    return false if players.uniq { |p| p[:hand] }.count == @@HANDS.count

    winning_player
  end

private

  def self.raise_error_if_unknown_hand(hand)
    raise Exception.new("unknown hand '#{hand.to_s}'") unless @@HANDS.has_key? hand
  end

  def self.duel(player_1, player_2)
    result = superior_hand(player_1[:hand], player_2[:hand])
    return result unless result # drop out if no result

    if result == player_1[:hand] then player_1 else player_2 end
  end

end

# A competition can have as many groups as it wants. 
# A group consists of 2 players. 
# The winner from each group moves forward. 
# New groups are created from matching the first winner with the second, etc.
# When there is only 1 winner left the competition is won.
# TODO: Players should have a predetermined list of hands to play or otherwise a random function.
# TODO: A round needs to be replayed if 2 hands are the same. For now we'll throw an exception.
class Competition

  # determine the victor
  # keep records of each round and each game in a round.
  def play(*participants)
    raise Exception.new("you need an even amount of participants") if participants.count.odd?

    rounds = 1
    games = []
    winner = play_round(rounds, participants, games)

    return {:winner => winner, :total_rounds => rounds, :games => games}
  end

private

  # recursive shizzle.
  def play_round(round, players, games)
    # when we have a final winner return him.
    return players.first if players.count == 1

    winners = []
    # place them in groups of 2
    if players.count > 2
      groups = make_groups(players) 
    else
      groups = [players]
    end

    # for each group play a game
    game_number = 0
    groups.each do |group|
      game_number += 1
      # binding.pry
      winner = GameMechanic.battle(group[0], group[1])
      winners << winner
      games << Game.new(:winner => winner, :loser => (group[0] == winner ? group[1] : group[0]), :round => round, :number => game_number)
    end

    # binding.pry
    play_round(round + 1, winners, games)
  end

  def make_groups(players)
    players.in_groups(2)
  end

end

class Game
  attr_accessor :winner, :loser, :round, :number

  def initialize(options)
    @winner = options[:winner]
    @loser = options[:loser]
    @round = options[:round]
    @number = options[:number]
  end
end

class Array
  # stolen from rails core
  def in_groups(number, fill_with = nil)
    # size / number gives minor group size;
    # size % number gives how many objects need extra accomodation;
    # each group hold either division or division + 1 items.
    division = size / number
    modulo = size % number

    # create a new array avoiding dup
    groups = []
    start = 0

    number.times do |index|
      length = division + (modulo > 0 && modulo > index ? 1 : 0)
      padding = fill_with != false &&
        modulo > 0 && length == division ? 1 : 0
      groups << slice(start, length).concat([fill_with] * padding)
      start += length
    end

    if block_given?
      groups.each{|g| yield(g) }
    else
      groups
    end
  end
end
