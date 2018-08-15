

# Get flagged phrases and put them in arrays
high_risk_phrases = []
low_risk_phrases = []

File.open("high_risk_phrases.txt").each do |line|
  high_risk_phrases.push(line.strip)
end

File.open("low_risk_phrases.txt").each do |line|
  low_risk_phrases.push(line.strip)
end

# Get file name and read file content
file_name = ARGV.first
file = ARGV.first
input = File.read(file)

# Find out how many occurrences of each phrase the text contains
nb_high_risk = 0
nb_low_risk = 0

high_risk_phrases.each do |phrase|
  nb_high_risk += 1 if input.downcase.include?(phrase.downcase)
end

low_risk_phrases.each do |phrase|
  nb_low_risk += 1 if input.downcase.include?(phrase.downcase)
end

# Calculate and save score to a text file
score = (nb_low_risk) + (nb_high_risk * 2)
File.open("offensive_scores.txt", "a") {|f| f.write("#{file_name}:#{score}") }
