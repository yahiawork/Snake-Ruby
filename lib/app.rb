# frozen_string_literal: true
require "gosu"
require_relative "config"
require_relative "storage/settings_store"
require_relative "storage/scores_store"
require_relative "ui/theme"
require_relative "ui/transition"
require_relative "screens/menu_screen"
require_relative "screens/game_screen"
require_relative "screens/scores_screen"
require_relative "screens/settings_screen"

class App < Gosu::Window
  def initialize
    @paths = Paths.new
    @settings = SettingsStore.load(@paths.settings_path)

    super(@settings.win_w, @settings.win_h, false)
    self.caption = "Snake Neon (Ruby + Gosu)"

    @theme = Theme.new
    @scores = ScoresStore.new(@paths.scores_path)
    @transition = Transition.new(@theme)

    @current = MenuScreen.new(@theme, @settings, @scores, self)
    @next = nil
  end

  def navigate_to(screen)
    return if @next
    @next = screen
    @transition.start
  end

  def go_menu     = navigate_to(MenuScreen.new(@theme, @settings, @scores, self))
  def go_game     = navigate_to(GameScreen.new(@theme, @settings, @scores, self))
  def go_scores   = navigate_to(ScoresScreen.new(@theme, @settings, @scores, self))
  def go_settings = navigate_to(SettingsScreen.new(@theme, @settings, @scores, self))

  def save_settings
    SettingsStore.save(@paths.settings_path, @settings)
    resize(@settings.win_w, @settings.win_h)
  end

  def update
    if @next
      @transition.update
      if @transition.done?
        @current = @next
        @next = nil
      end
    else
      @current.update
    end
  end

  def draw
    @theme.draw_background(width, height)
    @current.draw
    @transition.draw_overlay(width, height) if @next
  end

  def button_down(id)
    close if id == Gosu::KB_ESCAPE && Gosu.button_down?(Gosu::KB_LEFT_ALT)
    return if @next
    @current.button_down(id)
  end
end
