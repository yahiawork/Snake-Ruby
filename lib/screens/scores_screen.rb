# frozen_string_literal: true
require_relative "screen_base"

class ScoresScreen < ScreenBase
  def initialize(theme, settings, scores, app)
    super
    @rows = @scores.top(10)
  end

  def draw
    w = @app.width
    @theme.font_big.draw_text("HIGH SCORES", w / 2 - 170, 70, 2, 1, 1, @theme.c_accent)
    @theme.font.draw_text("ESC: BACK", w / 2 - 60, 130, 2, 1, 1, @theme.c_muted)

    y = 200
    if @rows.empty?
      @theme.font.draw_text("NO SCORES YET", w / 2 - 90, y, 2, 1, 1, @theme.c_muted)
      return
    end

    @rows.each_with_index do |r, i|
      name = r["name"].to_s
      score = r["score"].to_i
      line = format("%2d. %-12s %5d", i + 1, name[0, 12], score)
      @theme.font.draw_text(line, w / 2 - 140, y, 2, 1, 1, @theme.c_text)
      y += 34
    end
  end

  def button_down(id)
    @app.go_menu if id == Gosu::KB_ESCAPE
  end
end
