require "application_system_test_case"

class GamesTest < ApplicationSystemTestCase
  test 'Going to /new gives us a new random grid to play with' do
    visit new_url
    assert test: 'New game'
    assert_selector 'li', count: 10
  end

  test 'fills in the form and returns if it is a word or not' do
    visit new_url
    fill_in
    click_on 'Play'
  end
end
