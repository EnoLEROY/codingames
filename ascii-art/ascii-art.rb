# Auto-generated code below aims at helping you parse
# the standard input according to the problem statement.

l = gets.to_i
STDERR.puts l
h = gets.to_i
STDERR.puts h
t = gets.chomp.upcase.split('')
STDERR.puts t
rows = []
h.times do
  row = gets.chomp
  rows << row
end
STDERR.puts rows

# Write an answer using puts
# To debug: STDERR.puts "Debug messages..."
alphabet = ("A".."Z").to_a
alphabet << "?"

ascii_letters = rows.map do |row|
  row.scan(/.{1,#{l}}/)
end

answer = []
h.times do
  answer << []
end

t.each do |letter|
  alphabet.index(letter).nil? ? i = 26 : i = alphabet.index(letter)
  for j in 0...h
    answer[j] << ascii_letters[j][i]
  end
end

puts answer.map { |line| line.join('') }
