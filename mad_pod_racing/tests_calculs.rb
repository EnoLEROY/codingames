def distance(coords_a, coords_b)
  x = coords_b[0] - coords_a[0]
  y = coords_b[1] - coords_a[1]
  dist = Math.sqrt( (x * x) + (y * y) )
  return dist.to_i
end
puts distance([1, 2], [4, 6])

a = -20
puts a.abs

b = 90

puts (40..90)
puts (40..90).include?(b)



thrust_params = [
  [(0...10), 100],
  [(10...90), 70],
  [(90..180), 20]
]

next_checkpoint_angle = 40
thrust = []
thrust_params.each do |pair|
  p 'je suis dans le each'
  puts pair[0]
  puts pair[1]
  puts pair[0].include?(next_checkpoint_angle.abs)
  thrust << pair[1] if pair[0].include?(next_checkpoint_angle.abs)
end

puts thrust.join

# # ralentissement avant checkpoint
# if !last_dist.nil? && (last_dist - next_checkpoint_dist) > 0 && next_checkpoint_dist < 500 && thrust > 40
#   STDERR.puts "arriving to checkpoint"
#   if slowing_before_checkpoint == false
#     STDERR.puts "lowering thrust"
#     thrust = thrust / 2
#     slowing_before_checkpoint = true
#   end
# else
#   slowing_before_checkpoint = false
# end

# calcul du thrust
# thrust_params = [
#   { thrust: 100, angle: (0...10), distance: (0...5000)},
#   { thrust: 90,  angle: (10...20), distance: (0...5000)},
#   { thrust: 70,  angle: (20...45), distance: (0...5000)},
#   { thrust: 50,  angle: (0...10), distance: (0...5000)},
#   { thrust: 30,  angle: (0...10), distance: (0...5000)},
#   { thrust: 5,   angle: (0...10), distance: (0...5000)},
#   [(0...10), 100],
#   [(10...20), 90],
#   [(20...45), 70],
#   [(45...70), 50],
#   [(70...90), 30],
#   [(90...120), 5],
#   [(120..180), 5]
# ]
# temp = []
# thrust_params.each do |params|
#   thrust = params[:thrust] if params[:angle].include?(next_checkpoint_angle.abs)


#   temp << thrust
# end
# thrust = temp.join.to_i
