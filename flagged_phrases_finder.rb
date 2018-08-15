class FlaggedPhrasesFinder
  module Risk
    HIGH = 1
    LOW = 2
  end
  
  def initialize
    @high_risk_phrases = []
    @low_risk_phrases = []
  end
  
  def load_flagged_phrases file_name, risk
    File.open(file_name).each do |line|
      if risk == Risk::HIGH
        @high_risk_phrases.push(phrases_to_regexp(line.strip))
      elsif risk == Risk::LOW
        @low_risk_phrases.push(phrases_to_regexp(line.strip))
      else
        raise Exception.new("Unsupported risk type")
      end
    end
  end

  def phrases_occurences risk_phrases, content
    occurences = 0
    risk_phrases.each do |phrase|
      occurences += 1 if content.match(phrase)
      puts phrase if content.match(phrase)
    end
    return occurences
  end

  def score content
    nb_high_risk = phrases_occurences(@high_risk_phrases, content)
    nb_low_risk = phrases_occurences(@low_risk_phrases, content)
    score = (nb_low_risk) + (nb_high_risk * 2)
  end
  
  private
  def phrases_to_regexp phrase
    Regexp.new(Regexp.escape(phrase), "i")
  end
end

flagged_phrases_finder = FlaggedPhrasesFinder.new
flagged_phrases_finder.load_flagged_phrases("high_risk_phrases.txt", 1)
flagged_phrases_finder.load_flagged_phrases("low_risk_phrases.txt", 2)

files = Hash.new
ARGV.each do |arg|
  score = flagged_phrases_finder.score(File.read(arg))
  File.open("offensive_scores.txt", "a") {|f| f.write("#{arg}:#{score}\n") }
end
