# frozen_string_literal: true
require "json"
require_relative "../config"

module SettingsStore
  module_function

  def load(path)
    if File.exist?(path)
      Settings.new(JSON.parse(File.read(path)))
    else
      s = Settings.new
      save(path, s)
      s
    end
  rescue
    s = Settings.new
    save(path, s)
    s
  end

  def save(path, settings)
    File.write(path, JSON.pretty_generate(settings.to_h))
    true
  end
end
