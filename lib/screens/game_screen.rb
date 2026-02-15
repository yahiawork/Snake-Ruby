# frozen_string_literal: true
require_relative "screen_base"
require_relative "../game/snake"
require_relative "../game/world"

class GameScreen < ScreenBase
  def initialize(theme, settings, scores, app)
    super
    @snake = Snake.new
    @world = World.new(@settings)
    reset_round
    @last_step = Gosu.milliseconds
  end

  def reset_round
    @score = 0
    @game_over = false
    @snake.reset(@settings.grid_w / 2, @settings.grid_h / 2)
    @world.reset(@settings, @snake)
    @last_step = Gosu.milliseconds
  end

  def update
    return if @game_over
    now = Gosu.milliseconds
    if now - @last_step >= @settings.speed_ms
      @last_step = now
      step_game
    end
  end

  def step_game
    hx, hy = @snake.body[0]
    dx, dy = @snake.dir
    nx = hx + dx
    ny = hy + dy

    if @settings.wrap_walls
      nx, ny = @world.wrap!(nx, ny)
    else
      unless @world.inside?(nx, ny)
        trigger_game_over
        return
      end
    end

    if @snake.hits_self_next?(nx, ny)
      trigger_game_over
      return
    end

    fx, fy = @world.food
    ate = (nx == fx && ny == fy)
    @snake.step(grow: ate)
    if ate
      @score += 10
      @world.respawn_food(@snake)
    end
  end

  def trigger_game_over
    @game_over = true
    name = (@settings.player_name.to_s.strip.empty? ? "Player" : @settings.player_name.to_s.strip)
    @scores.add(name, @score)
  end

  def draw
    draw_grid
    draw_food
    draw_snake
    draw_hud
    draw_game_over if @game_over
  end

  def button_down(id)
    case id
    when Gosu::KB_ESCAPE
      @app.go_menu
    when Gosu::KB_R
      reset_round
    when Gosu::KB_RETURN, Gosu::KB_ENTER
      @app.go_menu if @game_over
    when Gosu::KB_UP, Gosu::KB_W
      @snake.set_dir(0, -1)
    when Gosu::KB_DOWN, Gosu::KB_S
      @snake.set_dir(0, 1)
    when Gosu::KB_LEFT, Gosu::KB_A
      @snake.set_dir(-1, 0)
    when Gosu::KB_RIGHT, Gosu::KB_D
      @snake.set_dir(1, 0)
    end
  end

  def draw_grid
    c = @theme.c_grid
    cell = @settings.cell
    (0..@settings.grid_w).each { |x| Gosu.draw_line(x * cell, 0, c, x * cell, @app.height, c, 1) }
    (0..@settings.grid_h).each { |y| Gosu.draw_line(0, y * cell, c, @app.width, y * cell, c, 1) }
  end

  def draw_food
    fx, fy = @world.food
    cell = @settings.cell
    x = fx * cell
    y = fy * cell
    glow_rect(x, y, cell, cell, @theme.c_food)
    Gosu.draw_rect(x + 2, y + 2, cell - 4, cell - 4, @theme.c_food, 3)
  end

  def draw_snake
    cell = @settings.cell
    @snake.body.each_with_index do |(x, y), i|
      px = x * cell
      py = y * cell
      col = (i == 0) ? @theme.c_good : Gosu::Color.rgba(90, 190, 130, 255)
      glow_rect(px, py, cell, cell, col)
      Gosu.draw_rect(px + 2, py + 2, cell - 4, cell - 4, col, 3)
    end
  end

  def draw_hud
    @theme.font.draw_text("SCORE: #{@score}", 12, 10, 5, 1, 1, @theme.c_text)
    @theme.font.draw_text("ESC: MENU  |  R: RESTART", 12, 34, 5, 1, 1, @theme.c_muted)
  end

  def draw_game_over
    Gosu.draw_rect(0, 0, @app.width, @app.height, Gosu::Color.rgba(0, 0, 0, 160), 8)
    @theme.font_big.draw_text("GAME OVER", @app.width / 2 - 160, @app.height / 2 - 80, 9, 1, 1, @theme.c_text)
    @theme.font.draw_text("R: RESTART", @app.width / 2 - 70, @app.height / 2 - 10, 9, 1, 1, @theme.c_muted)
    @theme.font.draw_text("ENTER: MENU", @app.width / 2 - 80, @app.height / 2 + 20, 9, 1, 1, @theme.c_muted)
  end

  def glow_rect(x, y, w, h, color)
    4.downto(1) do |i|
      a = 12 + (4 - i) * 12
      c = Gosu::Color.rgba(color.red, color.green, color.blue, a)
      Gosu.draw_rect(x - i * 3, y - i * 3, w + i * 6, h + i * 6, c, 2)
    end
  end
end
