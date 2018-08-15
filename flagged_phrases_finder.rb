class FlaggedPhrasesFinder
  module Risk
    HIGH = 1
    LOW = 2
  end
  
  def initialize count_occurences
    @high_risk_phrases = []
    @low_risk_phrases = []
    @count_occurences = count_occurences
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

  def nb_phrases_present risk_phrases, content
    nb_phrases = 0
    risk_phrases.each do |phrase|
      nb_phrases += 1 if content.match(phrase)
    end
    return nb_phrases
  end

  def count_phrases_occurences risk_phrases, content
    occurences = 0
    risk_phrases.each do |phrase|
      occurences += content.scan(phrase).count
    end
    return occurences
  end

  def score content
    if @count_occurences      
      nb_high_risk = count_phrases_occurences(@high_risk_phrases, content)
      nb_low_risk = count_phrases_occurences(@low_risk_phrases, content)
    else
      nb_high_risk = nb_phrases_present(@high_risk_phrases, content)
      nb_low_risk = nb_phrases_present(@low_risk_phrases, content)
    end
    score = (nb_low_risk) + (nb_high_risk * 2)
  end
  
  private
  def phrases_to_regexp phrase
    Regexp.new(Regexp.escape(phrase), "i")
  end
end

flagged_phrases_finder = FlaggedPhrasesFinder.new true
flagged_phrases_finder.load_flagged_phrases("high_risk_phrases.txt", 1)
flagged_phrases_finder.load_flagged_phrases("low_risk_phrases.txt", 2)

files = Hash.new
ARGV.each do |arg|
  score = flagged_phrases_finder.score(File.read(arg))
  File.open("offensive_scores.txt", "a") {|f| f.write("#{arg}:#{score}\n") }
end
