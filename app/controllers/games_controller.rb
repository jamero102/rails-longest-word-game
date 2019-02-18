require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    alph = ('A'..'Z').to_a
    @letters = []
    10.times do
      @letters << alph.sample
    end
  end

  def score
    @word = params[:word]
    attempt = @word.upcase.chars
    grid = params[:letters]
    include = attempt.select { |e| e if grid.count(e) < attempt.count(e) || !grid.include?(e) }.empty?
    dict_serialized = open("https://wagon-dictionary.herokuapp.com/#{@word}").read
    dict = JSON.parse(dict_serialized)
    @result = { score: 0, message: "Congratulations! #{@word.upcase} is a valid english word!" }
    if dict["found"] == true && include
      @result[:score] = dict["length"].to_i
    elsif !include then @result[:message] = "Sorry but #{@word.upcase} can't be built out of #{grid.gsub(' ', ', ')}"
    elsif !dict["found"] == true then @result[:message] = "Sorry but #{@word.upcase} does not seem to be an english word..."
    end
    if session[:score].nil?
      session[:score] = @result[:score]
    else
      session[:score] += @result[:score]
    end
    @score = session[:score]
  end
end
