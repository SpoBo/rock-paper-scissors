require 'pry'

t = [
       [
         [["Armando", "P"],["Dave", "S"]],
         [["Richard", "R"],["Michael", "S"]],
       ],
       [
         [["Allen", "S"],["Omer", "P"]],
         [["David E.", "R"], ["Richard X.", "P"]]
       ]
    ]


class NoSuchStrategyError < Exception
end

class WrongNumberOfPlayersError < Exception
end

def rps_game_winner(game)
    puts 'game:', game.inspect
    raise WrongNumberOfPlayersError.new unless game.length == 2
    if (game[0][1] =~ /[r]/i && game[1][1] =~ /[s]/i) || (game[0][1] =~ /[s]/i && game[1][1] =~ /[p]/i) || (game[0][1] =~ /[p]/i && game[1][1] =~ /[r]/i)
        return game[0]
    elsif (game[0][1] =~ /[r]/i && game[1][1] =~ /[p]/i) || (game[0][1] =~ /[s]/i && game[1][1] =~ /[r]/i) || (game[0][1] =~ /[p]/i && game[1][1] =~ /[s]/i)
        return game[1]
    elsif game[0][1] == game[1][1]
        return game[0]
    else
        raise NoSuchStrategyError.new
    end
end

def rps_tournament_winner(t)
   t.each do |pair|
      puts 
      puts 'winner:', yield(g)
   end  
end

rps_tournament_winner(t) { |x| rps_game_winner(x)  }