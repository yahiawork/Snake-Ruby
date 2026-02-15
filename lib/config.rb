# frozen_string_literal: true
require "json"

class Paths
  def initialize
    @data_dir = File.join(__dir__, "..", "data")
    Dir.mkdir(@data_dir) unless Dir.exist?(@data_dir)
  end
  def settings_path = File.join(@data_dir, "settings.json")
  def scores_path   = File.join(@data_dir, "scores.json")
end

class Settings
  attr_accessor :player_name, :grid_w, :grid_h, :cell, :speed_ms, :wrap_walls

  def initialize(h = {})
    @player_name = h.fetch("player_name", "Player")
    @grid_w      = h.fetch("grid_w", 32)
    @grid_h      = h.fetch("grid_h", 24)
    @cell        = h.fetch("cell", 22)
    @speed_ms    = h.fetch("speed_ms", 110)
    @wrap_walls  = h.fetch("wrap_walls", false)
  end

  def win_w = @grid_w * @cell
  def win_h = @grid_h * @cell

  def to_h
    {
      "player_name" => @player_name,
      "grid_w" => @grid_w,
      "grid_h" => @grid_h,
      "cell" => @cell,
      "speed_ms" => @speed_ms,
      "wrap_walls" => @wrap_walls
    }
  end
end
