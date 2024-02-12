STDOUT.sync = true # DO NOT REMOVE
# Save the Planet.
# Use less Fossil Fuel.

n = gets.to_i # the number of points used to draw the surface of Mars.
mars = []
n.times do
  # land_x: X coordinate of a surface point. (0 to 6999)
  # land_y: Y coordinate of a surface point. By linking all the points together in a sequential fashion, you form the surface of Mars.
  land_x, land_y = gets.split(" ").collect { |x| x.to_i }
  mars << [land_x, land_y]
end

# functions
def dist_to_ground(x, y, mars)
  temp = mars.index { |element| element[0] > x }
  a = mars[temp - 1]
  b = mars[temp]
  projete = a[1] - ((a[0] - x) * (a[1] - b[1]) / (a[0] - b[0]))
  dist = y - projete
  return dist
end

# program
landing_site = {
  start: 0,
  end: 0,
  height: 0
}
mars.each_with_index do |land, i|
  if land[1] == mars[i-1][1] && i > 0
    landing_site[:start] = mars[i-1][0]
    landing_site[:end] = land[0]
    landing_site[:height] = land[1]
  end
end
STDERR.puts landing_site




# game loop
loop do
  # hs: the horizontal speed (in m/s), can be negative.
  # vs: the vertical speed (in m/s), can be negative.
  # f: the quantity of remaining fuel in liters.
  # r: the rotation angle in degrees (-90 to 90). droite gauche
  # p: the thrust power (0 to 4).
  x, y, hs, vs, f, r, p = gets.split(" ").collect { |x| x.to_i }
  STDERR.puts "coords #{[x, y]}\nspeed h:#{hs}, v:#{vs}\nangle: #{r}, power:#{p}\nfuel: #{f}"

  # Write an action using puts
  # To debug: STDERR.puts "Debug messages..."

  # arriver au dessus de la zone
  # verifier la distance avec le sol
  # pour atterir verifier les conditions r = 0, hs < 40, vs < 20

  # calcul de l'angle
  distance_to_ground = dist_to_ground(x, y, mars)
  var = 300 # veriable de visée de la landing zone

  if (landing_site[:start]..landing_site[:end]).include?(x)
    site = "ON"
  elsif x > landing_site[:end]
    site = "LEFT"
  else
    site = "RIGHT"
  end
  STDERR.puts site

  if site == "ON"
    if hs.abs < 40 && vs.abs < 20
      angle = 0
    else
      power = 4
      angle = 0
    end 
  else
    angle = 30
    if hs.abs > 20
      power = 0
    else
      power = 4
    end
    if vs.abs > 40
      angle = 10
      power = 4
    end
    site == "RIGHT" ? angle = -angle : angle = angle
  end




  # R P. R is the desired rotation angle (-90, 90). P is the desired thrust power (0, 4).
  puts "#{angle} #{power}"
end
