# drone = {x: 50, y:50 }
# radius = 40

# enemies = {
#   1 => {
#     x: 10,
#     y: 90
#   },
#   2 => {
#     x: 90,
#     y: 50
#   },
#   3 => {
#     x: 50,
#     y: 90
#   }
# }

# target = {
#   x: 99,
#   y: 99
# }

# farthest_from_threat = {
#   possiblities: [],
#   distance_min_from_threat: 0
# } # sur un enemi random doit etre un {}
# points_on_circle = []
# increment = 1

# for x in (drone[:x] - radius)..(drone[:x] + radius)
#   for y in (drone[:y] - radius)..(drone[:y] + radius)
#     on_circle = ((x - drone[:x])**2 + (y - drone[:y])**2 <= (radius + increment)**2 && (x - drone[:x])**2 + (y - drone[:y])**2 >= (radius - increment)**2)
#     # on_circle = (x - drone[:x])**2 + (y - drone[:y])**2 == (radius)**2
#     puts "#{x}, #{y}: #{on_circle}"
#     if on_circle
#       distances = []
#       points_on_circle << {x: x, y: y}
#       enemies.each do |id, coords|
#         distance = Math.sqrt((x - coords[:x])**2 + (y - coords[:y])**2)
#         distances << distance
#       end

#       distance_min = distances.sort.first
#       # puts distance_min
#       # puts farthest_from_threat[:distance_min_from_threat]
#       if distance_min > (radius / 2)
#         farthest_from_threat[:distance_min_from_threat] = distance_min if farthest_from_threat[:distance_min_from_threat] <= distance_min
#         farthest_from_threat[:possiblities] << {x: x, y: y}
#       end
#     end
#   end
# end

# puts farthest_from_threat

# closest_to_target = { distance_to_target: 10000}
# farthest_from_threat[:possiblities].each do |possiblity|
#   distance = Math.sqrt((possiblity[:x] - target[:x])**2 + (possiblity[:y] - target[:y])**2)
#   if distance < closest_to_target[:distance_to_target]
#     closest_to_target = {x: possiblity[:x], y: possiblity[:y], distance_to_target: distance}
#   end
# end

# puts closest_to_target

# # grid = []
# # 100.times do
# #   grid << '.' * 100
# # end

# # # drone
# # grid[drone[:y]][drone[:x]] = "D"

# # # target
# # grid[target[:y]][target[:x]] = "T"


# # points_on_circle.each do |points|
# #   grid[points[:y]][points[:x]] = "°"
# # end

# # # possibilities
# # possibilities = farthest_from_threat[:possiblities]
# # possibilities.each do |possiblity|
# #   grid[possiblity[:y]][possiblity[:x]] = "p"
# # end

# # # closest_to_target
# # grid[closest_to_target[:y]][closest_to_target[:x]] = "C"

# # monsters = enemies.values
# # monsters.each do |monster|
# #   grid[monster[:y]][monster[:x]] = "m"
# # end

# # puts grid


# # puts (drone[:x] - radius)..(drone[:x])
# # range_x = (((drone[:x] - radius)/ 10)..(drone[:x]/10)).to_a
# # p range_x

# # p range_x

# # for i in range_x.map! {|x| x*10}
# #   puts i
# # end


# # intersection de 2 cercles :

# d = {
#   x: 22,
#   y: 30,
#   r: 20
# }

# m = {
#   x: 30,
#   y: 60,
#   r: 20
# }

# g = {
#   x: 0,
#   y: 0
# }

# h = {
#   x: 0,
#   y: 0
# }

# a = 2 * (m[:x]-d[:x])
# b = 2 * (m[:y]-d[:y])
# c = (m[:x]-d[:x])**2 + (m[:y]-d[:y])**2 - m[:r]**2 + d[:r]**2

# delta = (2*a*c)**2 - 4*(a**2+b**2)*(c**2-b**2*d[:r]**2)

# g[:x] = d[:x] + (2*a*c-Math.sqrt(delta))/(2*(a**2+b**2))
# h[:x] = d[:x] + (2*a*c+Math.sqrt(delta))/(2*(a**2+b**2))

# if b == 0
#   g[:y] = d[:y] + b/2 + Math.sqrt(m[:r]**2 - ((2*c-a**2)/(2*a))**2)
#   h[:y] = d[:y] + b/2 - Math.sqrt(m[:r]**2 - ((2*c-a**2)/(2*a))**2)
# else
#   g[:y] = d[:y] + (c-a*(g[:x]-d[:x]))/b
#   h[:y] = d[:y] + (c-a*(h[:x]-d[:x]))/b
# end

# grid = []
# 100.times do
#   grid << '.' * 100
# end

# puts d
# puts m
# puts g
# puts h

# grid[d[:y]][d[:x]] = "D"
# grid[m[:y]][m[:x]] = "M"
# grid[g[:y]][g[:x]] = "G"
# grid[h[:y]][h[:x]] = "H"

# # puts grid.map {|x| x.split('').join(' ')}

# def intersection_cercles(cercle_a, cercle_b)
#   # cercle_a = { x: 22, y: 30, r: 20 }
#   # cercle_b = { x: 30, y: 60, r: 20 }
#   g = { x: 0, y: 0 }
#   h = { x: 0, y: 0 }

#   a = 2 * (cercle_b[:x]-cercle_a[:x])
#   b = 2 * (cercle_b[:y]-cercle_a[:y])
#   c = (cercle_b[:x]-cercle_a[:x])**2 + (cercle_b[:y]-cercle_a[:y])**2 - cercle_b[:r]**2 + cercle_a[:r]**2

#   delta = (2*a*c)**2 - 4*(a**2+b**2)*(c**2-b**2*cercle_a[:r]**2)

#   g[:x] = cercle_a[:x] + (2*a*c-Math.sqrt(delta))/(2*(a**2+b**2))
#   h[:x] = cercle_a[:x] + (2*a*c+Math.sqrt(delta))/(2*(a**2+b**2))

#   if b == 0
#     g[:y] = cercle_a[:y] + b/2 + Math.sqrt(cercle_b[:r]**2 - ((2*c-a**2)/(2*a))**2)
#     h[:y] = cercle_a[:y] + b/2 - Math.sqrt(cercle_b[:r]**2 - ((2*c-a**2)/(2*a))**2)
#   else
#     g[:y] = cercle_a[:y] + (c-a*(g[:x]-cercle_a[:x]))/b
#     h[:y] = cercle_a[:y] + (c-a*(h[:x]-cercle_a[:x]))/b
#   end
#   return [g, h]
# end

# # angle entre 2 vecteurs
# # teta = cos-1 ( produitvectoriel / produit des longueurs )

# d = {
#   x: 22,
#   y: 30
# }

# m = {
#   x: 30,
#   y: 60
# }

# t = {
#   x: 70,
#   y: 10
# }

# dm = {
#   x: (d[:x] - m[:x]).abs,
#   y: (d[:y] - m[:y]).abs,
#   longueur: Math.sqrt((d[:x] - m[:x])**2 + (d[:y] - m[:y])**2)
# }

# dt = {
#   x: (d[:x] - t[:x]).abs,
#   y: (d[:y] - t[:y]).abs,
#   longueur: Math.sqrt((d[:x] - t[:x])**2 + (d[:y] - t[:y])**2)
# }

# produit_vectoriel = dm[:x]*dt[:x] + dm[:y]*dt[:y]
# produit_longueurs = dm[:longueur] * dt[:longueur]

# angle = Math.acos(produit_vectoriel/produit_longueurs)

# angle_deg = angle * 180/Math::PI
# puts angle
# puts angle_deg

# grid = []
# 100.times do
#   grid << '.' * 100
# end

# grid[d[:y]][d[:x]] = "D"
# grid[m[:y]][m[:x]] = "M"
# grid[t[:y]][t[:x]] = "T"
# puts grid.map {|x| x.split('').join(' ')}

def angle_entre_vecteurs(d, m, t)
  # d = { x: 22, y: 30 } point commun
  dm = {
    x: m[:x] - d[:x],
    y: m[:y] - d[:y],
    longueur: Math.sqrt((d[:x] - m[:x])**2 + (d[:y] - m[:y])**2)
  }
  dt = {
    x: t[:x] - d[:x],
    y: t[:y] - d[:y],
    longueur: Math.sqrt((d[:x] - t[:x])**2 + (d[:y] - t[:y])**2)
  }

  produit_vectoriel = dm[:x]*dt[:x] + dm[:y]*dt[:y]
  produit_longueurs = dm[:longueur] * dt[:longueur]

  angle = Math.acos(produit_vectoriel/produit_longueurs)
  angle_deg = angle * 180/Math::PI
  return angle_deg
end


# def centre_gravite(sommets)
#   x_up = 0
#   x_down = 0
#   y_up = 0
#   y_down = 0

#   for i in 0...sommets.length
#     x = sommets[i][0]
#     y = sommets[i][1]
#     x_1 = sommets[i-1][0]
#     y_1 = sommets[i-1][1]

#     x_up += (x_1 + x)*(x_1*y - y_1*x)
#     x_down += (x_1*y - y_1*x)

#     y_up += (y_1 + y)*(x_1*y - y_1*x)
#     y_down += (x_1*y - y_1*x)
#   end

#   x = x_up / (3*x_down)
#   y = y_up / (3*y_down)

#   return [x.to_i, y.to_i]
# end

# d = {
#   x: 22,
#   y: 30
# }

# m = {
#   x: 30,
#   y: 60
# }

# t = {
#   x: 70,
#   y: 40
# }

# drone =

# def opposed_destination(sommets, drone)
#   if sommets.length == 1
#     return sommets.first
#   elsif sommets.length == 2
#     x = (sommets[0][0] - sommets[1][0]) / 2 + sommets[1][0]
#     y = (sommets[0][1] - sommets[1][1]) / 2 + sommets[1][1]
#     return [x.to_i, y.to_i]
#   else
#     x_up = 0
#     x_down = 0
#     y_up = 0
#     y_down = 0

#     for i in 0...sommets.length
#       x = sommets[i][0]
#       y = sommets[i][1]
#       x_1 = sommets[i-1][0]
#       y_1 = sommets[i-1][1]

#       x_up += (x_1 + x)*(x_1*y - y_1*x)
#       x_down += (x_1*y - y_1*x)

#       y_up += (y_1 + y)*(x_1*y - y_1*x)
#       y_down += (x_1*y - y_1*x)
#     end

#     x = x_up / (3*x_down)
#     y = y_up / (3*y_down)

#     return [x.to_i, y.to_i]
#   end
# end

# sommets = []
# sommets << d
# sommets << m
# sommets << t

# sommets.map! do |x|
#   x.values
# end
# p sommets

# # centre = centre_gravite(sommets)
# # p centre



# grid = []
# 100.times do
#   grid << '.' * 100
# end

# grid[d[:y]][d[:x]] = "D"
# grid[m[:y]][m[:x]] = "M"
# grid[t[:y]][t[:x]] = "T"
# grid[centre[0]][centre[1]] = "0"

# puts grid.map {|x| x.split('').join(' ')}


def distance_point_vecteur(point, start, finish) # {x: x, y: y}
  a = (start[:y]-finish[:y]) / (start[:x]-finish[:x])
  b = ((start[:x]*finish[:y]) - (start[:y]*finish[:x])) / (start[:x]-finish[:x])

  distance = (point[:y] - a*point[:x] - b).abs / Math.sqrt(1+a**2)

  return distance.to_i
end

def projection_ordonnee(point, start, finish)
  x_vecteur = finish[:x] - start[:x]
  y_vecteur = finish[:y] - start[:y]

  normale = ((point[:x]-start[:x])*x_vecteur + (point[:y]-start[:y])*y_vecteur) / Math.sqrt(x_vecteur**2 + y_vecteur**2)

  x_projetee = start[:x] + (normale / Math.sqrt(x_vecteur**2 + y_vecteur**2)) * x_vecteur
  y_projetee = start[:y] + (normale / Math.sqrt(x_vecteur**2 + y_vecteur**2)) * y_vecteur

  return [x_projetee.to_i, y_projetee.to_i]
end

# d = {
#   x: 20,
#   y: 30
# }

# t = {
#   x: 20,
#   y: 40
# }

# m = {
#   x: 40,
#   y: 10
# }

# grid = []
# 100.times do
#   grid << '.' * 100
# end

# grid[d[:y]][d[:x]] = "D"
# grid[m[:y]][m[:x]] = "M"
# grid[t[:y]][t[:x]] = "T"
# projete = projection_ordonnee(m, d, t)
# grid[projete[1]][projete[0]] = "H"


# puts grid.map {|x| x.split('').join(' ')}
# puts "projeté de m sur dt"
# # puts distance_point_vecteur(m, d, t)
# puts projete

def vecteur_to_unitaire(vector, unit) # {x: , y:}
  norme = Math.sqrt(vector[:x]**2 + vector[:y]**2)
  u = {}
  u[:x] = (unit * vector[:x] / norme).to_i
  u[:y] = (unit * vector[:y] / norme).to_i
  return u
end

puts vecteur_to_unitaire({x: 3, y: 5}, 25)


def point_dans_triangle(sommet_1, sommet_2, sommet_3, point)
  angle_1 = angle_entre_vecteurs(point, sommet_1, sommet_2)
  angle_2 = angle_entre_vecteurs(point, sommet_1, sommet_3)
  angle_3 = angle_entre_vecteurs(point, sommet_3, sommet_2)

  somme = angle_1 + angle_2 + angle_3
  if somme <= 360 && somme >= 357
    return true
  else
    return false
  end
end

def distance_point_vecteur(point, start, finish)
  vecteur_normal = {x: - (finish[:y] - start[:y]), y: (finish[:x] - start[:x])}
  vecteur_point_start = {x: (point[:x] - start[:x]), y: (point[:y] - start[:y])}

  # vecteur normal en unitaire
  norme = Math.sqrt(vecteur_normal[:x]**2 + vecteur_normal[:y]**2)
  vecteur_normal[:x] = vecteur_normal[:x] / norme
  vecteur_normal[:y] = vecteur_normal[:y] / norme

  distance = (vecteur_normal[:x] * vecteur_point_start[:x] + vecteur_normal[:y] * vecteur_point_start[:y]).abs
  return distance.to_i
end

d = {
  x: 50,
  y: 50
}

i = {
  x: 20,
  y: 60
}

j = {
  x: 80,
  y: 10
}

k = {
  x: 50,
  y: 70
}

grid = []
100.times do
  grid << '.' * 100
end

grid[d[:y]][d[:x]] = "D"
grid[i[:y]][i[:x]] = "i"
grid[j[:y]][j[:x]] = "j"
grid[k[:y]][k[:x]] = "k"
puts grid.map {|x| x.split('').join(' ')}
# puts "v2"
# puts distance_point_vecteur(m, t, d)

puts point_dans_triangle(i, j, k, d)
