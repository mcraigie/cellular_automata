require './game.rb'
require 'benchmark'

def benchmark_game(threads: 1, game_size: 100, iterations: 100)
  puts "Threads: #{threads}, Size: #{game_size}^2, Iterations: #{iterations}"

  Benchmark.bm do |x|
    x.report do
      iterations.times do
        game = Game.new(x_size: game_size, y_size: game_size)
        game.tick while !game.barren? && !game.stalled?
      end
    end
  end
end

benchmark_game
