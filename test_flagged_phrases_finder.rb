require 'minitest/autorun'
require_relative './flagged_phrases_finder.rb'

class TestFlaggedPhrasesFinder < Minitest::Test
  def setup
    high_risk_phrases = "Kitten\ncat\n"
    low_risk_phrases = "Some puppies\n"
    File.open("test_phrases1.txt", "a") {|f| f.write(high_risk_phrases)}
    File.open("test_phrases2.txt", "a") {|f| f.write(low_risk_phrases)}
    @content = "Cat mojo asdflkjaertvlkjasntvkjn (sits on keyboard) then cats take over the world or chew iPad power cord"
    @flagged_phrases_finder = FlaggedPhrasesFinder.new(false)
    @flagged_phrases_finder.load_flagged_phrases("test_phrases1.txt", FlaggedPhrasesFinder::Risk::HIGH)
    @flagged_phrases_finder.load_flagged_phrases("test_phrases2.txt", FlaggedPhrasesFinder::Risk::LOW)
  end

  def teardown
    File.delete("test_phrases1.txt")
    File.delete("test_phrases2.txt")
  end

  def test_created
    assert @flagged_phrases_finder != nil
  end
  
  def test_phrases_loaded
    high_risk_phrases = @flagged_phrases_finder.instance_variable_get(:@high_risk_phrases)
    low_risk_phrases = @flagged_phrases_finder.instance_variable_get(:@low_risk_phrases)
    assert_equal /Kitten/i, high_risk_phrases[0]
    assert_equal /cat/i, high_risk_phrases[1]
    assert_equal /Some\ puppies/i, low_risk_phrases[0]
    assert_equal 2, high_risk_phrases.count
    assert_equal 1, low_risk_phrases.count
  end
  
  def test_raises_exception_when_wrong_risk_type
    exception = assert_raises Exception do
      @flagged_phrases_finder.load_flagged_phrases("test_phrases1.txt", 3)
    end
    assert_equal "Unsupported risk type", exception.message
  end
  
  def test_nb_phrases_present
    regexp = @flagged_phrases_finder.instance_variable_get(:@high_risk_phrases)
    result = @flagged_phrases_finder.nb_phrases_present(regexp, @content)
    assert_equal 1, result
  end

  def test_count_phrases_occurences
    flagged_phrases_finder = FlaggedPhrasesFinder.new(true)
    flagged_phrases_finder.load_flagged_phrases("test_phrases1.txt", FlaggedPhrasesFinder::Risk::HIGH)
    regexp = flagged_phrases_finder.instance_variable_get(:@high_risk_phrases)
    result = flagged_phrases_finder.count_phrases_occurences(regexp, @content)
    assert_equal 2, result
  end
  
  def test_score_count_occurences_true
    flagged_phrases_finder = FlaggedPhrasesFinder.new(true)
    flagged_phrases_finder.load_flagged_phrases("test_phrases1.txt", FlaggedPhrasesFinder::Risk::HIGH)
    flagged_phrases_finder.load_flagged_phrases("test_phrases2.txt", FlaggedPhrasesFinder::Risk::LOW)
    score = flagged_phrases_finder.score("There was a cat, another cat a kitten and some puppies")
    assert_equal 7, score
  end

  def test_score_count_occurences_false
    score = @flagged_phrases_finder.score("There was a cat, another cat a kitten and some puppies")
    assert_equal 5, score
  end
end
