require 'colorize'

# Currently this is the most basic Conway's game of life cell type.
# I'm going to cut out the next_if_x methods/type and replace them with
# a 'scheme' class. This will allow me to keep the same Cell object for the
# duration of the game, but allow different schemes based on the
# cell's current type.
class Cell
  def initialize(initial_type = :dead)
    self.type = initial_type
  end

  def type(tick = nil)
    tick.nil? ? @type_history.last : @type_history[tick]
  end

  def type=(next_type)
    @type_history ||= []
    @type_history << next_type
  end

  # live cell w fewer than 2 live neighbours dies (underpopulation)
  # live cell w 2 or 3 live neighbours lives on to the next generation
  # live cell w more than 3 live neighbours dies (overpopulation)
  # dead cell w exactly 3 live neighbours becomes a live cell (reproduction)
  def choose_next(neighbours, tick)
    neighbour_types = neighbours.reject(&:nil?).select(&:alive?)
    neighbour_types.map! { |i| i.type(tick) }

    self.type = if alive?
                  next_if_alive(neighbour_types)
                else
                  next_if_dead(neighbour_types)
                end
  end

  def next_if_alive(neighbour_types)
    if neighbour_types.size.between?(2, 3)
      :alive
    else
      :dead
    end
  end

  def next_if_dead(neighbour_types)
    if neighbour_types.size == 3
      :alive
    else
      :dead
    end
  end

  def alive?
    type != :dead ? true : false
  end

  def to_s
    type.to_s
  end

  # TODO: remove dependency on the colorize gem
  # This ./* notation is very similar to some of the cellular automata
  # file format. I would like to make each rendering of the game state a valid
  # save file for that state. I may need to make my own format depending on how
  # I introduce more exotic cell scheme.
  def to_c
    if alive?
      '.'.colorize(color: :blue, background: :blue)
    else
      '*'.colorize(color: :white, background: :white)
    end
  end

  private :type=, :next_if_alive, :next_if_dead
end
