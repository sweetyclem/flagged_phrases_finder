require 'minitest/autorun'
require_relative './flagged_phrases_finder.rb'

class TestFlaggedPhrasesFinder < Minitest::Test
  def test_created
    flagged_phrases_finder = FlaggedPhrasesFinder.new(false)
    assert flagged_phrases_finder != nil
  end
  
  def test_phrases_loaded
    phrases = "Kitten\nSome puppies\nchicks"
    File.open("test_phrases.txt", "a") {|f| f.write(phrases) }
    flagged_phrases_finder = FlaggedPhrasesFinder.new(false)
    flagged_phrases_finder.load_flagged_phrases("test_phrases.txt", FlaggedPhrasesFinder::Risk::HIGH)
    high_risk_phrases = flagged_phrases_finder.instance_variable_get(:@high_risk_phrases)
    assert_equal /Kitten/i, high_risk_phrases[0]
    assert_equal /Some\ puppies/i, high_risk_phrases[1]
    assert_equal /chicks/i, high_risk_phrases[2]
    assert_equal 3, high_risk_phrases.count
    File.delete("test_phrases.txt")
  end
  
  def test_raises_exception_when_wrong_risk_type
    phrases = "Kitten\nSome puppies\nchicks"
    File.open("test_phrases.txt", "a") {|f| f.write(phrases) }
    flagged_phrases_finder = FlaggedPhrasesFinder.new(false)
    exception = assert_raises Exception do
      flagged_phrases_finder.load_flagged_phrases("test_phrases.txt", 3)
    end
    assert_equal "Unsupported risk type", exception.message
    File.delete("test_phrases.txt")
  end
  
  def test_nb_phrases_present
    phrases = ["cat"]
    content = "Cat mojo asdflkjaertvlkjasntvkjn (sits on keyboard) then cats take over the world or chew iPad power cord"
    flagged_phrases_finder = FlaggedPhrasesFinder.new(false)
    result = flagged_phrases_finder.nb_phrases_present(phrases, content)
    assert_equal 1, result
  end
end
