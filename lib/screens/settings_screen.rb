# frozen_string_literal: true
require_relative "screen_base"

class SettingsScreen < ScreenBase
  ITEMS = ["SPEED_MS", "WRAP_WALLS", "BACK"].freeze

  def initialize(theme, settings, scores, app)
    super
    @index = 0
  end

  def draw
    w = @app.width
    @theme.font_big.draw_text("SETTINGS", w / 2 - 120, 70, 2, 1, 1, @theme.c_accent)
    @theme.font.draw_text("UP/DOWN: MOVE  |  LEFT/RIGHT: CHANGE", w / 2 - 250, 130, 2, 1, 1, @theme.c_muted)

    y = 230
    ITEMS.each_with_index do |it, i|
      sel = (i == @index)
      if sel
        glow_rect(w / 2 - 250, y - 10, 500, 46, @theme.c_accent)
        Gosu.draw_rect(w / 2 - 250, y - 10, 500, 46, Gosu::Color.rgba(26, 28, 38, 230), 1)
      end

      value = case it
              when "SPEED_MS" then @settings.speed_ms.to_s
              when "WRAP_WALLS" then @settings.wrap_walls ? "TRUE" : "FALSE"
              else ""
              end

      @theme.font.draw_text(it, w / 2 - 220, y, 2, 1, 1, sel ? @theme.c_text : @theme.c_muted)
      @theme.font.draw_text(value, w / 2 + 120, y, 2, 1, 1, sel ? @theme.c_accent : @theme.c_muted) unless value.empty?
      y += 64
    end

    @theme.font.draw_text("ESC: BACK", w / 2 - 60, @app.height - 60, 2, 1, 1, @theme.c_muted)
  end

  def button_down(id)
    case id
    when Gosu::KB_UP
      @index = (@index - 1) % ITEMS.size
    when Gosu::KB_DOWN
      @index = (@index + 1) % ITEMS.size
    when Gosu::KB_LEFT
      change(-1)
    when Gosu::KB_RIGHT
      change(+1)
    when Gosu::KB_ESCAPE
      @app.go_menu
    when Gosu::KB_RETURN, Gosu::KB_ENTER
      @app.go_menu if ITEMS[@index] == "BACK"
    end
  end

  def change(dir)
    case ITEMS[@index]
    when "SPEED_MS"
      @settings.speed_ms = [[@settings.speed_ms + dir * 10, 50].max, 220].min
      @app.save_settings
    when "WRAP_WALLS"
      @settings.wrap_walls = !@settings.wrap_walls
      @app.save_settings
    end
  end

  def glow_rect(x, y, w, h, color)
    4.downto(1) do |i|
      a = 12 + (4 - i) * 12
      c = Gosu::Color.rgba(color.red, color.green, color.blue, a)
      Gosu.draw_rect(x - i * 3, y - i * 3, w + i * 6, h + i * 6, c, 0)
    end
  end
end
