require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    letters_array = ("A".."Z").to_a
    @letters = []
    10.times do
      @letters << letters_array.sample
    end
  end

  def score
    @letters = params[:letters].split(" ")
    @word = params[:word]
    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    word_serialized = open(url).read
    word_test = JSON.parse(word_serialized)
    if word_test['found'] && check_word(@word, @letters) == true
      @score = "Well done! Your score was #{word_test['length']}"
    elsif word_test['found'] == false
      @score = "Your entry (#{@word}) does not exist. Try English next time..."
    else
      @score = "Your entry (#{@word}) did not match the available letters in the grid. Try again."
    end
  end

  def check_word(word, letters)
    (word.upcase.split(//) - letters).empty?
  end
end
