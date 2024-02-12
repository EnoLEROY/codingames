STDOUT.sync = true # DO NOT REMOVE
# Auto-generated code below aims at helping you parse
# the standard input according to the problem statement.

boost = 1
start_time = Time.now
# game loop
loop do
  # next_checkpoint_x: x position of the next check point
  # next_checkpoint_y: y position of the next check point
  # next_checkpoint_dist: distance to the next checkpoint
  # next_checkpoint_angle: angle between your pod orientation and the direction of the next checkpoint
  x, y, next_checkpoint_x, next_checkpoint_y, next_checkpoint_dist, next_checkpoint_angle = gets.split(" ").collect { |x| x.to_i }
  opponent_x, opponent_y = gets.split(" ").collect { |x| x.to_i }

  STDERR.puts "my pod: #{[x, y]}\nnext checkpoint: \n#{[next_checkpoint_x, next_checkpoint_y]}, a: #{next_checkpoint_angle}, d: #{next_checkpoint_dist}"
  # Write an action using puts
  # To debug: STDERR.puts "Debug messages..."
  answer = []


  # You have to output the target position
  # followed by the power (0 <= thrust <= 100)
  # i.e.: "x y thrust"
  # printf("%d %d 80\n", next_checkpoint_x, next_checkpoint_y)

  # calcul du thrust
  # ralentissement avant checkpoint
  param_dist = 3000
  min_thrust = 20
  thrust = [[(next_checkpoint_dist.to_f / param_dist) * 100, 100].min, min_thrust].max

  # enfonction de l'angle
  thrust = [(thrust - (next_checkpoint_angle.abs.to_f / 3)), min_thrust].max
  thrust = min_thrust if next_checkpoint_angle.abs > 100
  thrust = 100 if (90..100).include?(thrust)
  thrust = thrust.to_i

  if boost > 0 && next_checkpoint_dist > 6000 && next_checkpoint_angle.abs == 0 && (Time.now - start_time) > 2
    thrust = "BOOST"
    boost -= 1
  end
  STDERR. puts "boost used" if boost == 0

  # rectification de la trajectoire


  answer << next_checkpoint_x.to_i
  answer << next_checkpoint_y.to_i
  answer << thrust
  puts answer.join(' ')
end

