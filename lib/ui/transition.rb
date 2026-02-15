# frozen_string_literal: true
class Transition
  def initialize(theme)
    @theme = theme
    @t = 1.0
    @active = false
  end

  def start
    @t = 0.0
    @active = true
  end

  def update
    return unless @active
    @t += 0.035 # slow & smooth
    if @t >= 1.0
      @t = 1.0
      @active = false
    end
  end

  def done? = !@active

  def draw_overlay(w, h)
    return if done?
    eased = ease_out_cubic(@t)
    alpha = (255 * (1.0 - eased)).to_i
    c = Gosu::Color.rgba(@theme.c_accent.red, @theme.c_accent.green, @theme.c_accent.blue, (alpha * 0.18).to_i)
    Gosu.draw_rect(0, 0, w, h, c, 10)
    Gosu.draw_rect(0, 0, w, h, Gosu::Color.rgba(0, 0, 0, (alpha * 0.35).to_i), 9)
  end

  def ease_out_cubic(x)
    p = 1.0 - x
    1.0 - p * p * p
  end
end
