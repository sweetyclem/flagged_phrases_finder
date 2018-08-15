high_risk_phrases = []
low_risk_phrases = []
# Get flagged phrases and put them in arrays
File.open("high_risk_phrases.txt").each do |line|
  high_risk_phrases.push(line.strip)
end
File.open("low_risk_phrases.txt").each do |line|
  low_risk_phrases.push(line.strip)
end

file_content = gets.chomp
score = 0
