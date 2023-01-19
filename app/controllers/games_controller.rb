require 'net/http'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = ('A'..'Z').to_a.shuffle.take(9)
  end

  def score
    @guess = params[:guess]
    @letters = params[:letters]
    @valid = valid?
  end

  private

  def valid?
    test = []
    @guess.chars.compact.each do |letter|
      test << @letters.match?(letter.upcase)
      @letters.delete(letter)
    end

    url = "https://wagon-dictionary.herokuapp.com/#{@guess}"
    result = Net::HTTP.get(URI(url))
    parsed = JSON.parse(result)
    return false if !parsed['found'] || test.include?(false)

    true
  end
end
