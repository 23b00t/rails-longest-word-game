require 'net/http'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = (0..9).map { ('A'..'Z').to_a.sample }
  end

  def score
    @guess = params[:guess]
    @letters = params[:letters]
    @valid = valid?
  end

  private

  def valid?
    test = []
    letters = @letters.dup
    @guess.delete(' ').chars.each do |letter|
      test << letters.match?(letter.upcase)
      letters.delete!(letter.upcase)
    end

    url = "https://wagon-dictionary.herokuapp.com/#{@guess}"
    parsed = JSON.parse(Net::HTTP.get(URI(url)))
    return false if !parsed['found'] || test.include?(false)

    true
  end
end
