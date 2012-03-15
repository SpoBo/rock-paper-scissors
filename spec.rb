require_relative 'logic'
require 'bundler/setup'

describe GameMechanic do

  describe '::superior_hand' do

    it 'knows that rock beats scissors' do
      GameMechanic.superior_hand(:rock, :scissors).should eql(:rock)
    end

    it 'knows that scissors beats paper' do
      GameMechanic.superior_hand(:scissors, :paper).should eql(:scissors)
    end

    it 'knows that paper beats rock' do
      GameMechanic.superior_hand(:rock, :paper).should eql(:paper)
    end

    it 'returns false when equal hands' do
      GameMechanic.superior_hand(:rock, :rock).should be_false
    end

    it 'throws exception on unknown hand' do
      expect { GameMechanic.superior_hand(:oink, :rock)}.to raise_error "unknown hand 'oink'"
    end

  end

  describe '::battle' do
    let(:rock_player) { {:name => 'Vincent', :hand => :rock}}
    let(:paper_player) { {:name => 'Daan', :hand => :paper}}
    let(:scissors_player) { {:name => 'Daan', :hand => :scissors}}
    let(:scissors_player_2) { {:name => 'Daan Cloney', :hand => :scissors}}

    it 'should return a clear winner for 2 players' do
      GameMechanic.battle(rock_player, scissors_player).should eql(rock_player)
    end

    it 'should return false when only 1 player' do
      GameMechanic.battle(rock_player).should be_false
    end

    it 'should return a clear winner for 3 players' do
      GameMechanic.battle(rock_player, scissors_player, scissors_player).should eql(rock_player)
    end

    it 'should return false when all hands are equal' do
      GameMechanic.battle(scissors_player, scissors_player_2).should be_false
    end

    it 'should return false when all hands all different hands are present' do
      GameMechanic.battle(scissors_player, rock_player, paper_player).should be_false
    end
  end

end

describe Competition do

  # winner wins in round , game 1.
  # loser 3 wins in round 1, game 2.
  # winner wins in round 2, game 1.
  let(:winner) { {:name => 'Winner', :hand => :rock}}
  let(:loser_1) { {:name => 'Loser 1', :hand => :scissors}}
  let(:loser_2) { {:name => 'Loser 2', :hand => :paper}}
  let(:loser_3) { {:name => 'Loser 3', :hand => :scissors}}

  describe 'when added 3 players' do

    it 'should throw an exception mentioning that we need an even number of players' do
      expect { Competition.new.play(winner, loser_1, loser_2) }.to raise_error "you need an even amount of participants"
    end

  end

  describe 'when added 2 players' do

    subject { Competition.new.play(winner, loser_1) }

    it 'should be concluded in 1 round' do
      subject[:total_rounds].should eql(1)
    end

    it 'should be concluded in 1 game with the correct winner and loser' do
      subject[:games].count.should eql(1)
      subject[:games][0].winner.should eql(winner)
      subject[:games][0].loser.should eql(loser_1)
      subject[:games][0].round.should eql(1)
      subject[:games][0].number.should eql(1)
    end

    it 'should be won by winner' do
      subject[:winner].should eql(winner)
    end

  end

  describe 'when added 4 players' do

    subject { Competition.new.play(winner, loser_1, loser_2, loser_3) }

    it 'should be concluded in 3 games' do
      subject[:games].count.should eql(3)
    end

    it 'should be won by winner' do
      subject[:winner].should eql(winner)
    end

    it 'should mark round 1, game 1 won by winner' do
      subject[:games][0].winner.should eql(winner)
      subject[:games][0].loser.should eql(loser_1)
      subject[:games][0].round.should eql(1)
      subject[:games][0].number.should eql(1)
    end

    it 'should mark round 1, game 2 won by loser_3' do
      subject[:games][1].winner.should eql(loser_3)
      subject[:games][1].loser.should eql(loser_2)
      subject[:games][1].round.should eql(1)
      subject[:games][1].number.should eql(2)
    end

    it 'should mark round 2, game 1 won by winner' do
      subject[:games][2].winner.should eql(winner)
      subject[:games][2].loser.should eql(loser_3)
      subject[:games][2].round.should eql(2)
      subject[:games][2].number.should eql(1)
    end
    
  end

end