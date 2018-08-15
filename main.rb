require_relative './flagged_phrases_finder.rb'

flagged_phrases_finder = FlaggedPhrasesFinder.new(true)
flagged_phrases_finder.load_flagged_phrases("high_risk_phrases.txt", FlaggedPhrasesFinder::Risk::HIGH)
flagged_phrases_finder.load_flagged_phrases("low_risk_phrases.txt", FlaggedPhrasesFinder::Risk::LOW)

files = Hash.new
ARGV.each do |arg|
  score = flagged_phrases_finder.score(File.read(arg))
  File.open("offensive_scores.txt", "a") {|f| f.write("#{arg}:#{score}\n") }
end
