require 'open-uri'
require 'json'

class GamesController < ApplicationController
  VOWELS = ["A", "E", "I", "O", "U"]
  ALPHABET = ('A'..'Z').to_a

  def new
    @letters = Array.new(5) { VOWELS.sample }
    @letters += Array.new(5) { (('A'..'Z').to_a - VOWELS).sample }
    @letters.shuffle!
  end

  def score
    # use user word as endpoint and parse
    @word = (params[:word] || ' ').upcase
    @letters = params[:letters].split
    @is_english = english_word?(@word)
    @result = included?(@word, @letters)
  end

  private

  def included?(word, letters)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end

  def english_word?(word)
    heroku_endpoint = 'https://wagon-dictionary.herokuapp.com'
    user_word_endpoint = "#{heroku_endpoint}/#{word}"
    word_serialized = URI.open(user_word_endpoint).read
    @json_word = JSON.parse(word_serialized)
    @json_word['found']
  end
end
