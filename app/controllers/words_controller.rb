require 'open-uri'
require 'json'


class WordsController < ApplicationController
  def game
    @grid = generate_grid(15)
    @start_time = Time.now
  end

  def score
   @attempt = params[:answer]
   @start_time = Time.parse(params[:start_time])
   @end_time = Time.now
   @result = run_game(@attempt, params[:grid],@start_time, @end_time)
 end

 def generate_grid(grid_size)
  # TODO: generate random grid of letters
  array = []
  grid_size.times { array << (65 + rand(25)).chr }
  return array
end

def true_or_false(attempt)
  words = File.read('/usr/share/dict/words').upcase.split("\n")
  words.any? { |word| attempt.upcase == word.upcase }
end

def get_translation(attempt)
  api_key = "a7d84ea0-7fef-4251-9c70-5d9887fd1215"
  att = attempt.downcase
  url = "https://api-platform.systran.net/translation/text/translate?source=en&target=fr&key=#{api_key}&input=#{att}"
  translation = open(url).read
  word_database = JSON.parse(translation)
  return word_database["outputs"][0]["output"]
end

def check_grid(attempt, grid)
  attempt.upcase!
  attempt.split("").all? { |x| attempt.count(x) <= grid.count(x) }
end

def run_game(attempt, grid, start_time, end_time)
  # TODO: runs the game and return detailed hash of result
  if true_or_false(attempt) && check_grid(attempt, grid)
    result = {
      time: end_time - start_time,
      translation: get_translation(attempt),
      score: attempt.length - (end_time - start_time),
      message: "well done"
    }
  elsif check_grid(attempt, grid)
    result = {
      time: end_time - start_time,
      translation: nil,
      score: 0,
      message: "not an english word"
    }
  else
    result = {
      time: end_time - start_time,
      translation: get_translation(attempt),
      score: 0,
      message: "not in the grid"
    }
  end
  return result
end

end
