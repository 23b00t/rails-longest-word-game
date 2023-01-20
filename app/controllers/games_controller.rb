require 'net/http'
require 'json'

class GamesController < ApplicationController
  def new
    @start_time = Time.now
    @letters = (0..9).map { ('A'..'Z').to_a.sample }
  end

  def score
    @start_time = Time.parse(params[:start_time])
    @end_time = Time.now
    @guess = params[:guess].delete(' ')
    @letters = params[:letters].delete(' ')
    @result = result
  end

  private

  def valid_word?
    url = "https://wagon-dictionary.herokuapp.com/#{@guess}"
    parsed = JSON.parse(Net::HTTP.get(URI(url)))
    return false unless parsed['found']

    true
  end

  def valid_letters?
    test = []
    letters = @letters.dup
    @guess.chars.each do |letter|
      test << letters.match?(letter.upcase)
      letters.sub!(letter.upcase, '')
    end
    return false if test.include?(false)

    true
  end

  def result
    return 'That is not an English word!' unless valid_word?

    return 'You are only allowed to use the displayed letters' unless valid_letters?

    points = @guess.length * (@end_time - @start_time) * 23
    "Good job! Your score is #{points.round}"
  end
end
