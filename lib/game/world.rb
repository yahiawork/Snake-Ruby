# frozen_string_literal: true
class World
  attr_reader :food

  def initialize(settings)
    @settings = settings
    @rng = Random.new
    @food = [0, 0]
  end

  def reset(settings, snake)
    @settings = settings
    respawn_food(snake)
  end

  def inside?(x, y)
    x >= 0 && x < @settings.grid_w && y >= 0 && y < @settings.grid_h
  end

  def respawn_food(snake)
    loop do
      fx = @rng.rand(0...@settings.grid_w)
      fy = @rng.rand(0...@settings.grid_h)
      next if snake.hits?(fx, fy)
      @food = [fx, fy]
      return
    end
  end

  def wrap!(x, y)
    x = @settings.grid_w - 1 if x < 0
    x = 0 if x >= @settings.grid_w
    y = @settings.grid_h - 1 if y < 0
    y = 0 if y >= @settings.grid_h
    [x, y]
  end
end
