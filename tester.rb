require './game.rb'

def test_game(game_size: 10, threads: 1)
  puts "Threads: #{threads}, Size: #{game_size}^2"

  game = Game.new(x_size: game_size, y_size: game_size, threads: threads)
  game.populate_random(600)

  while !game.barren? && !game.stalled?
    puts game.to_s
    puts "generation: #{game.generation}, population: #{game.population}\n\n"
    game.tick
  end

  puts "final state:\n" + game.to_s
end

test_game
