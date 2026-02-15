# frozen_string_literal: true
require_relative "screen_base"

class MenuScreen < ScreenBase
  ITEMS = ["PLAY", "HIGH SCORES", "SETTINGS", "QUIT"].freeze

  def initialize(theme, settings, scores, app)
    super
    @index = 0
    @blink = 0.0
  end

  def update
    @blink += 0.03
  end

  def draw
    w = @app.width
    @theme.font_big.draw_text("SNAKE NEON", w / 2 - 160, 60, 2, 1, 1, @theme.c_accent)
    @theme.font.draw_text("ARROWS / ENTER", w / 2 - 80, 120, 2, 1, 1, @theme.c_muted)

    y = 200
    ITEMS.each_with_index do |it, i|
      sel = (i == @index)
      if sel
        glow_rect(w / 2 - 220, y - 10, 440, 46, @theme.c_accent)
        Gosu.draw_rect(w / 2 - 220, y - 10, 440, 46, Gosu::Color.rgba(26, 28, 38, 230), 1)
      end
      color = sel ? @theme.c_text : @theme.c_muted
      @theme.font.draw_text(it, w / 2 - 60, y, 2, 1, 1, color)
      y += 64
    end

    hint_alpha = (120 + 80 * Math.sin(@blink)).to_i
    @theme.font.draw_text("TIP: CHANGE SPEED IN SETTINGS", w / 2 - 170, @app.height - 60, 2, 1, 1,
                          Gosu::Color.rgba(@theme.c_muted.red, @theme.c_muted.green, @theme.c_muted.blue, hint_alpha))
  end

  def button_down(id)
    case id
    when Gosu::KB_UP
      @index = (@index - 1) % ITEMS.size
    when Gosu::KB_DOWN
      @index = (@index + 1) % ITEMS.size
    when Gosu::KB_RETURN, Gosu::KB_ENTER
      case @index
      when 0 then @app.go_game
      when 1 then @app.go_scores
      when 2 then @app.go_settings
      when 3 then @app.close
      end
    end
  end

  def glow_rect(x, y, w, h, color)
    4.downto(1) do |i|
      a = 18 + (4 - i) * 10
      c = Gosu::Color.rgba(color.red, color.green, color.blue, a)
      Gosu.draw_rect(x - i * 3, y - i * 3, w + i * 6, h + i * 6, c, 0)
    end
  end
end
