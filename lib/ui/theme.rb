# frozen_string_literal: true
require "gosu"

class Theme
  attr_reader :font, :font_big

  def initialize
    @font = Gosu::Font.new(22, name: Gosu.default_font_name)
    @font_big = Gosu::Font.new(44, name: Gosu.default_font_name)
    @bg0 = Gosu::Color.rgba(14, 16, 22, 255)
    @bg1 = Gosu::Color.rgba(10, 12, 18, 255)
    @grid = Gosu::Color.rgba(28, 30, 40, 255)
    @text = Gosu::Color.rgba(235, 238, 245, 255)
    @muted = Gosu::Color.rgba(150, 158, 174, 255)
    @accent = Gosu::Color.rgba(90, 140, 255, 255)
    @good = Gosu::Color.rgba(120, 230, 160, 255)
    @food = Gosu::Color.rgba(255, 95, 110, 255)
  end

  def c_text = @text
  def c_muted = @muted
  def c_accent = @accent
  def c_good = @good
  def c_food = @food
  def c_grid = @grid

  def draw_background(w, h)
    step = 12
    strips = (h / step).to_i
    (0..strips).each do |i|
      t = strips.zero? ? 0.0 : i.to_f / strips.to_f
      r = (@bg0.red   + (@bg1.red   - @bg0.red)   * t).to_i
      g = (@bg0.green + (@bg1.green - @bg0.green) * t).to_i
      b = (@bg0.blue  + (@bg1.blue  - @bg0.blue)  * t).to_i
      Gosu.draw_rect(0, i * step, w, step, Gosu::Color.rgba(r, g, b, 255), 0)
    end
  end
end
