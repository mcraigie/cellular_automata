require './cell.rb'

# This class stores and manages the game grid
class Game
  attr_reader :generation

  def initialize(x_size: 10, y_size: 10, threads: 1)
    @x_size = x_size
    @y_size = y_size
    @threads = threads

    @generation = 0
    stage_population_count
    stage_grid
  end

  def stage_grid(type = nil)
    @grid = Array.new(@x_size) do
      Array.new(@y_size) do
        type.nil? ? Cell.new : Cell.new(type)
      end
    end
  end

  def populate_random(n)
    n.times do
      set(rand(0...@x_size), rand(0...@y_size), :alive)
    end
  end

  def tick
    stage_population_count

    grid_each do |cell, x, y|
      neighbours = get_neighbours(x, y)
      cell.choose_next(neighbours, @generation)
      increase_population_count if cell.alive?
    end

    @generation += 1
  end

  def grid_each
    @grid.each_with_index do |col_e, col_i|
      col_e.each_with_index do |row_e, row_i|
        yield(row_e, col_i, row_i)
      end
    end
  end

  def set(x, y, type)
    cell = Cell.new(type)
    @grid[x][y] = cell
    increase_population_count if cell.alive?
  end

  def get(x, y)
    @grid[x][y]
  rescue NoMethodError
    nil
  end

  def get_neighbours(x, y)
    [
      [x + 1, y - 1], [x - 1, y + 1],
      [x + 1, y + 1], [x - 1, y - 1],
      [x,     y + 1], [x,     y - 1],
      [x + 1,     y], [x - 1,     y]
    ].map { |x_, y_| get(x_, y_) }
  end

  def to_s
    buffer = ''
    @grid.map { |g| g.map(&:to_c).reverse }.transpose.each do |c|
      buffer += c.join('') + "\n"
    end
    buffer
  end

  def population
    @population_history.last
  end

  def increase_population_count
    @population_history[-1] += 1
  end

  def stage_population_count
    @population_history ||= []
    @population_history << 0
  end

  def stalled?(n: 4)
    recent = @population_history.last(n)
    recent.size == n && recent.uniq.length == 1 ? true : false
  end

  def barren?
    @generation > 0 && population.zero? ? true : false
  end

  private :increase_population_count,
          :stage_population_count,
          :stage_grid,
          :get_neighbours,
          :grid_each
end
