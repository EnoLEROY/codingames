# Auto-generated code below aims at helping you parse
# the standard input according to the problem statement.

# w, h, count_x, count_y = gets.split(" ").collect { |x| x.to_i }
# inputs = gets.split(" ")
# colones =[]
# for i in 0..(count_x-1)
#   x = inputs[i].to_i
#   colones << x
# end
# inputs = gets.split(" ")
# lines = []
# for i in 0..(count_y-1)
#   y = inputs[i].to_i
#   lines << y
# end

# colones << w
# lines << h

colones = [11, 25, 26, 29, 30, 40, 44, 56, 65, 71, 87, 98, 100, 108, 130, 149, 153, 161, 173, 179, 200]
lines = [1, 11, 16, 17, 19, 37, 38, 53, 65, 69, 100]

colone_add = []
for i in 0...colones.length
  for j in (i+1)...colones.length
    colone_add << colones[j] - colones[i]
  end
end

colones << colone_add
colones.flatten!

line_add = []
for i in 0...lines.length
  for j in (i+1)...lines.length
    line_add << lines[j] - lines[i]
  end
end

lines << line_add
lines.flatten!

res = 0
colones.each do |col|
  lines.each do |lin|
    res += 1 if col == lin
  end
end

puts res
