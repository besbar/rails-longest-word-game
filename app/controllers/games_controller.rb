require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = []
    letter = ("A".."Z").to_a
    10.times { @letters.push(letter.sample) }
  end

  def score
    @letters = params[:letters]
    @word_in_grid = true
    @word = params[:word].upcase
    @word.chars.each do |x|
      @letters.include?(x) ? @letters[@letters.index(x)] = '0' : (@word_in_grid = false)
    end
    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    user_serialized = URI.open(url).read
    @http_request = JSON.parse(user_serialized)
    if !@http_request["found"]
      @results = "Sorry but #{@word} does not seem to be an english word..."
    elsif @http_request["found"] && @word_in_grid
      @results = "Congratulations #{@word} is a valid English word! Your score is #{@word.length}"
    else
      @results = "Sorry but #{@word} cannot be built out of #{@letters}"
    end
  end
end
