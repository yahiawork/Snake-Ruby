# frozen_string_literal: true
class Snake
  attr_reader :body, :dir

  def initialize
    @body = []
    @dir = [1, 0]
    @pending = [1, 0]
  end

  def reset(x, y)
    @body = [[x, y], [x - 1, y], [x - 2, y]]
    @dir = [1, 0]
    @pending = @dir
  end

  def set_dir(dx, dy)
    return if dx == -@dir[0] && dy == -@dir[1]
    @pending = [dx, dy]
  end

  def step(grow: false)
    @dir = @pending
    hx, hy = @body[0]
    nx = hx + @dir[0]
    ny = hy + @dir[1]
    @body.unshift([nx, ny])
    @body.pop unless grow
    [nx, ny]
  end

  def hits?(x, y)
    @body.any? { |p| p[0] == x && p[1] == y }
  end

  def hits_self_next?(nx, ny)
    @body.any? { |p| p[0] == nx && p[1] == ny }
  end
end
