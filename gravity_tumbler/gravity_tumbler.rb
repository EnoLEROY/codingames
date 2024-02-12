# Auto-generated code below aims at helping you parse
# the standard input according to the problem statement.

width, height = gets.split.map { |x| x.to_i }
count = gets.to_i
grid = []
height.times do
  raster = gets.chomp
  grid << raster
end

# grid = [".................",
# ".................",
# "...##...###..#...",
# ".####..#####.###.",
# "#################"]
# print "how many times > "
# count = gets.chomp.strip.to_i
# Write an answer using puts
# To debug: STDERR.puts "Debug messages..."

def turn_counter_clockwise(array)
  new_grid = []
  array.first.length.times do 
    new_grid << "0" * array.length
  end
  
  array.each_with_index do |line, line_id|
    line.split('').each_with_index do |char, char_id|
      new_grid[(line.length - 1) - char_id][line_id] = char
    end 
  end
  return new_grid
end

def gravity_to_right(array)
  gravited = array.map do |line|
    line.split('').sort.join
  end
  return gravited
end

count.times do
  grid = gravity_to_right(grid)
  grid = turn_counter_clockwise(grid)
end

puts grid
