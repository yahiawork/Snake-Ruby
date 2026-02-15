# frozen_string_literal: true
require "json"
require "time"

class ScoresStore
  def initialize(path)
    @path = path
    ensure_file
  end

  def ensure_file
    return if File.exist?(@path)
    File.write(@path, JSON.pretty_generate({ "scores" => [] }))
  end

  def all
    JSON.parse(File.read(@path)).fetch("scores", [])
  rescue
    []
  end

  def top(limit = 10)
    all.sort_by { |r| -r.fetch("score", 0).to_i }.first(limit)
  end

  def add(name, score)
    rows = all
    rows << { "name" => (name.to_s.strip.empty? ? "Player" : name.to_s.strip),
              "score" => score.to_i,
              "created_at" => Time.now.iso8601 }
    File.write(@path, JSON.pretty_generate({ "scores" => rows }))
    true
  end
end
