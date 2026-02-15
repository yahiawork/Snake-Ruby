# frozen_string_literal: true
class ScreenBase
  def initialize(theme, settings, scores, app)
    @theme = theme
    @settings = settings
    @scores = scores
    @app = app
  end
  def update; end
  def draw; end
  def button_down(_id); end
end
