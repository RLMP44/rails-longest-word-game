require 'open-uri'
require 'json'

class GamesController < ApplicationController
  VOWELS = ["A", "E", "I", "O", "U"]
  ALPHABET = ('A'..'Z').to_a

  def home
  end

  def new
    @letters = Array.new(5) { VOWELS.sample }
    @letters += Array.new(5) { (('A'..'Z').to_a - VOWELS).sample }
    @letters.shuffle!
  end

  def score
    # use user word as endpoint and parse
    @word = (params[:word] || ' ').upcase
    @input = params[:word]
    @letters = params[:letters].split
    @is_english = english_word?(@word)
    @result = included?(@word, @letters)
    @final_display = create_display(@result, @is_english, @input, @letters)
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

  def create_display(result, is_english, input, letters)
    if result && is_english
      "Congrats, that's a valid word!"
    elsif result == false
      "Sorry, but #{input} can't be built out of #{letters.join(',')}"
    elsif is_english == false
      "Sorry, but #{input} doesn't seem to be a valid English word..."
    else
      'Reached else statement'
    end
  end
end
