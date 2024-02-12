mars = [[0, 100], [1000, 500], [1500, 1500], [3000, 1000], [4000, 150], [5500, 150], [6999, 800]]


def dist_to_ground(x, y, mars)
  temp = mars.index { |element| element[0] > x }
  a = mars[temp - 1]
  b = mars[temp]
  projete = a[1] - ((a[0] - x) * (a[1] - b[1]) / (a[0] - b[0]))
  dist = y - projete
  return dist
end

puts dist_to_gound(2500, 2699, mars)
puts dist_to_gound(1300, 2, mars)
