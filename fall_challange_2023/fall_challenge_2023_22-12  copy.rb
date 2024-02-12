STDOUT.sync = true # DO NOT REMOVE
# Score points by scanning valuable fish faster than your opponent.

# fontions ---------------------------------------------------------------------
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

def vecteur_to_unitaire(vector, unit) # {x: , y:}
  norme = Math.sqrt(vector[:x]**2 + vector[:y]**2)
  u = {}
  u[:x] = (unit * vector[:x] / norme)
  u[:y] = (unit * vector[:y] / norme)

  u[:x] = 0 if u[:x].nan?
  u[:y] = 0 if u[:y].nan?

  u[:x] = u[:x].to_i
  u[:y] = u[:y].to_i
  return u
end

def projection_ordonnee(point, start, finish)
  x_vecteur = finish[:x] - start[:x]
  y_vecteur = finish[:y] - start[:y]

  normale = ((point[:x]-start[:x])*x_vecteur + (point[:y]-start[:y])*y_vecteur) / Math.sqrt(x_vecteur**2 + y_vecteur**2)

  x_projetee = start[:x] + (normale / Math.sqrt(x_vecteur**2 + y_vecteur**2)) * x_vecteur
  y_projetee = start[:y] + (normale / Math.sqrt(x_vecteur**2 + y_vecteur**2)) * y_vecteur

  return [x_projetee.to_i, y_projetee.to_i]
end

def intersection_cercles(cercle_a, cercle_b)
  # cercle_a = { x: 22, y: 30, r: 20 }
  # cercle_b = { x: 30, y: 60, r: 20 }
  g = { x: 0, y: 0 }
  h = { x: 0, y: 0 }

  a = 2 * (cercle_b[:x]-cercle_a[:x])
  b = 2 * (cercle_b[:y]-cercle_a[:y])
  c = (cercle_b[:x]-cercle_a[:x])**2 + (cercle_b[:y]-cercle_a[:y])**2 - cercle_b[:r]**2 + cercle_a[:r]**2

  delta = (2*a*c)**2 - 4*(a**2+b**2)*(c**2-b**2*cercle_a[:r]**2)

  g[:x] = (cercle_a[:x] + (2*a*c-Math.sqrt(delta))/(2*(a**2+b**2))).to_i
  h[:x] = (cercle_a[:x] + (2*a*c+Math.sqrt(delta))/(2*(a**2+b**2))).to_i

  if b == 0
    g[:y] = (cercle_a[:y] + b/2 + Math.sqrt(cercle_b[:r]**2 - ((2*c-a**2)/(2*a))**2)).to_i
    h[:y] = (cercle_a[:y] + b/2 - Math.sqrt(cercle_b[:r]**2 - ((2*c-a**2)/(2*a))**2)).to_i
  else
    g[:y] = (cercle_a[:y] + (c-a*(g[:x]-cercle_a[:x]))/b).to_i
    h[:y] = (cercle_a[:y] + (c-a*(h[:x]-cercle_a[:x]))/b).to_i
  end
  return [g, h]
end

def centre_gravite(sommets)
  if sommets.length == 1
    return sommets.first
  elsif sommets.length == 2
    x = (sommets[0][0] - sommets[1][0]) / 2 + sommets[1][0]
    y = (sommets[0][1] - sommets[1][1]) / 2 + sommets[1][1]
    return [x.to_i, y.to_i]
  else
    x_up = 0
    x_down = 0
    y_up = 0
    y_down = 0

    for i in 0...sommets.length
      x = sommets[i][0]
      y = sommets[i][1]
      x_1 = sommets[i-1][0]
      y_1 = sommets[i-1][1]

      x_up += (x_1 + x)*(x_1*y - y_1*x)
      x_down += (x_1*y - y_1*x)

      y_up += (y_1 + y)*(x_1*y - y_1*x)
      y_down += (x_1*y - y_1*x)
    end

    x = x_up / (3*x_down)
    y = y_up / (3*y_down)

    return [x.to_i, y.to_i]
  end
end

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

  if (produit_vectoriel/produit_longueurs).abs > 1
    angle = 0
  else
    angle = Math.acos(produit_vectoriel/produit_longueurs)
  end
  angle_deg = angle * 180/Math::PI
  angle_deg = 1000 if angle_deg.nan?
  return angle_deg.to_i
end


# classes ----------------------------------------------------------------------

class Creature
  attr_accessor :id, :color, :type, :x, :y, :vx, :vy, :scanned, :localisation_by_radar, :distance_to_drone, :last_update, :coords_updated
  def initialize(attrs)
    @id = attrs[:id]
    @color = attrs[:color]
    @type = attrs[:type]
    @x = attrs[:x] || nil
    @y = attrs[:y] || nil
    @coords_updated = false
    @last_update = 0
    @turns = 0
    @vx = attrs[:vx] || nil
    @vy = attrs[:vy] || nil
    @scanned = false
    @localisation_by_radar = [] # [drone, localisation]
    @distance_to_drone = nil
    @last_update = 0
  end

  def update_position(drones)
    @turns += 1
    if @type == -1
      if coords_updated == true
        @last_update = @turns
        @coords_updated = false
      elsif @vx == nil || @x == nil
      elsif (@turns - @last_update) >= 4
        @x = nil
        @y = nil
      else
        vector = {x: @vx, y: vy}
        drone_nearby = false
        drones.each do |drone_id, drone|
          distance = Math.sqrt((@x - drone.x)**2 + (@y - drone.y)**2)
          if drone.ligths_on == 1 && distance < 2000
            drone_nearby = true
          elsif drone.ligths_on == 0 && distance < 800
            drone_nearby = true
          end
        end
        if drone_nearby
          vitesse = 540
        else
          vitesse = 270
        end
        new_vector = vecteur_to_unitaire(vector, vitesse)

        @vx = new_vector[:x]
        @vy = new_vector[:y]

        if @y < 2500
          @vx = - @vx
          @vy = - @vy
        end
        @x += @vx
        @y += @vy
      end
    else
      if coords_updated == true
        @last_update = @turns
        @coords_updated = false
      else
        @x = nil
        @y = nil
      end
    end
  end
end

class Drone
  attr_accessor :id, :owner, :x, :y, :emergency, :battery, :direction, :directions_archives, :creatures_scanned, :target_creature, :avoid_monster_vector, :ligths_on
  def initialize(attrs)
    @id = attrs[:id]
    @owner = attrs[:owner]
    @x = attrs[:x]
    @y = attrs[:y]
    @emergency = attrs[:emergency]
    @battery = attrs[:battery]
    @direction = nil
    @directions_archives = []
    @creatures_scanned = []
    @target_creature = nil
    @avoid_monster_vector = {x: 0, y: 0}
    @ligths_on = false
  end
end

class Projection
  attr_accessor :id, :type, :x, :y, :drone, :distance_to_drone
  def initialize(attrs)
    @id = attrs[:id]
    @type = attrs[:type]
    @x = attrs[:x] || nil
    @y = attrs[:y] || nil
    @drone = attrs[:drone]
    @distance_to_drone = nil
  end
end

# inputs -----------------------------------------------------------------------

CREATURES = {}
creature_count = gets.to_i
creature_count.times do
  creature_id, color, type = gets.split.map { |x| x.to_i }
  creature = Creature.new({id: creature_id, color: color, type: type})
  CREATURES[creature_id] = creature
end

DRONES = {}
MY_DRONES = {}
RADAR = {}
PROJECTIONS = {}

turns = 0
# game loop
saved = []
loop do
  turns += 1

  monsters_ids = CREATURES.values.select {|x| x.type == -1}
  monsters_ids.map! {|x| x.id}
  # STDERR.puts "aggressi creatures #{monsters_ids}"
  fishies_ids = CREATURES.values.select {|x| x.type != -1}
  fishies_ids.map! {|x| x.id}

  my_score = gets.to_i
  foe_score = gets.to_i

  my_scan_count = gets.to_i
  my_scan_count.times do
    creature_id = gets.to_i
    # CREATURES[creature_id].scanned = true
    saved << creature_id
  end
  saved.uniq!
  STDERR.puts "saved: #{saved}"


  foe_scan_count = gets.to_i
  foe_scan_count.times do
    creature_id = gets.to_i
  end

  my_drone_count = gets.to_i
  my_drone_count.times do
    drone_id, drone_x, drone_y, emergency, battery = gets.split.map { |x| x.to_i }
    if DRONES[drone_id].nil?
      drone = Drone.new({id: drone_id, owner: "me", x: drone_x, y: drone_y, emergency: emergency, battery: battery})
      DRONES[drone_id] = drone
      MY_DRONES[drone_id] = DRONES[drone_id]
      id = PROJECTIONS.keys.length
      PROJECTIONS[id] = Projection.new({id: id, type: "left", drone: drone})
      id = PROJECTIONS.keys.length
      PROJECTIONS[id] = Projection.new({id: id, type: "right", drone: drone})
      id = PROJECTIONS.keys.length
      PROJECTIONS[id] = Projection.new({id: id, type: "bottom", drone: drone})
    else
      DRONES[drone_id].x = drone_x
      DRONES[drone_id].y = drone_y
      DRONES[drone_id].emergency = emergency
      DRONES[drone_id].battery = battery
    end
    RADAR[drone_id] = {
      "TL" => [],
      "TR" => [],
      "BL" => [],
      "BR" => []
    }
  end

  PROJECTIONS.each do |id, projection|
    case projection.type
    when "left"
      projection.x = 0
      projection.y = projection.drone.y
      projection.distance_to_drone = projection.drone.x
    when "right"
      projection.x = 10000
      projection.y = projection.drone.y
      projection.distance_to_drone = 10000 - projection.drone.x
    when "bottom"
      projection.x = projection.drone.x
      projection.y = 10000
      projection.distance_to_drone = 10000 - projection.drone.y
    end
  end


  # STDERR.puts "PROJECTIONS(#{PROJECTIONS.keys.length}): #{PROJECTIONS}"
  # STDERR.puts "MY_DRONES: #{MY_DRONES}"

  foe_drone_count = gets.to_i
  foe_drone_count.times do
    drone_id, drone_x, drone_y, emergency, battery = gets.split.map { |x| x.to_i }
    if DRONES[drone_id].nil?
      drone = Drone.new({id: drone_id, owner: "foe", x: drone_x, y: drone_y, emergency: emergency, battery: battery})
      DRONES[drone_id] = drone
    else
      DRONES[drone_id].x = drone_x
      DRONES[drone_id].y = drone_y
      DRONES[drone_id].emergency = emergency
      if emergency == 1
        DRONES[drone_id].creatures_scanned = []
      end
      DRONES[drone_id].battery = battery
    end
  end

  # resset des créatures scnnées par chacun des drones
  MY_DRONES.each do |drone_id, drone|
    drone.creatures_scanned = []
  end


  drone_scan_count = gets.to_i
  drone_scan_count.times do
    drone_id, creature_id = gets.split.map { |x| x.to_i }
    CREATURES[creature_id].scanned = true if MY_DRONES.keys.include?(drone_id)
    MY_DRONES[drone_id].creatures_scanned << creature_id if MY_DRONES.keys.include?(drone_id)
    # STDERR.puts "#{MY_DRONES[drone_id].creatures_scanned}" if MY_DRONES.keys.include?(drone_id)
    # STDERR.puts "drone scan count : drone #{drone_id}, creature #{creature_id}"
  end

  found_creatures = saved.map {|x| x}
  MY_DRONES.each do |id, drone|
    found_creatures << drone.creatures_scanned
    STDERR.puts "drone #{id} scanned: #{drone.creatures_scanned}, batterie: #{drone.battery}"
  end
  found_creatures.flatten!.uniq!
  STDERR.puts "creatures found: #{found_creatures}"

  visible_creatures = []
  visible_creature_count = gets.to_i
  visible_creature_count.times do
    creature_id, creature_x, creature_y, creature_vx, creature_vy = gets.split.map { |x| x.to_i }
    # STDERR.puts "#{creature_id}, #{creature_x}, #{creature_y}, #{creature_vx}, #{creature_vy}"
    # STDERR.puts "visible #{creature_id}"
    CREATURES[creature_id].x = creature_x
    CREATURES[creature_id].y = creature_y
    CREATURES[creature_id].vx = creature_vx
    CREATURES[creature_id].vy = creature_vy
    CREATURES[creature_id].coords_updated = true
    visible_creatures << creature_id
  end
  STDERR.puts "visible creatures: #{visible_creatures}"
  # prediction des emplacements des creatures
  CREATURES.each do |id, creature|
    creature.update_position(DRONES)
    STDERR.puts "creature #{id}: #{creature.x}, #{creature.y}, #{creature.vx}, #{creature.vy}, #{creature.last_update}" if creature.type == -1
  end

  present_creatures = []
  radar_blip_count = gets.to_i
  radar_blip_count.times do
    drone_id, creature_id, radar = gets.split
    # STDERR.puts "radar : #{radar}"
    drone_id = drone_id.to_i
    creature_id = creature_id.to_i
    CREATURES[creature_id].localisation_by_radar = [drone_id, radar]
    RADAR[drone_id][radar] << creature_id
    # STDERR.puts "#{RADAR[drone_id][radar]}"
    # RADAR[drone_id][radar].uniq!
    present_creatures << creature_id
  end
  present_creatures.uniq!
  possible_scan = present_creatures.select do |id|
    !found_creatures.include?(id) && fishies_ids.include?(id)
  end
  STDERR.puts "possible scan #{possible_scan}"
  # STDERR.puts "#{RADAR}"


  visible_fishies = [] # id, x, y
  visible_monsters = [] # id, x, y
  known_monsters = []
  CREATURES.each do |id, creature|
    if visible_creatures.include?(id)
      visible_fishies << id if fishies_ids.include?(id)
      visible_monsters << id if monsters_ids.include?(id)
    end
    if monsters_ids.include?(id) && !creature.x.nil?
      known_monsters << id
    end
  end
  STDERR.puts "visble fishes #{visible_fishies}, visible monsters #{visible_monsters}, known monsters: #{known_monsters}"

  visible_fishies.delete_if do |fish_id|
    found_creatures.include?(fish_id)
  end


  # descisions -----------------------------------------------------------------
  MY_DRONES.each do |drone_id, drone|
    # etat des light par default
    STDERR.puts "-- infos drone #{drone_id} --"
    drone.battery < 15 ? light_frequance = 5 : light_frequance = 3
    (turns + drone_id) % light_frequance == 0 ? light = 1 : light = 0
    light = 0 if drone.battery == 0
    # light = 0 if drone.y < 2000
    # CREATURES.each do |creature_id, creature|
    #   if creature.type == -1 && !creature.x.nil?
    #     distance_monster_drone = Math.sqrt((drone.x - creature.x)**2 + (drone.y - creature.y)**2)
    #     if distance_monster_drone < 2000
    #       if (drone.y < 8500 || drone.x > 1500 || drone.x < 8500)
    #         light = 0
    #       else
    #         turns % 2 == 0 ? light = 1 : light = 0
    #       end
    #     end
    #   end
    # end

    # conditions de remontée ---------------------------------------------------
    if drone.creatures_scanned.length >= 4 || possible_scan == 0 || (drone.direction == "SURFACE" && drone.creatures_scanned.length > 0) #|| (drone.y < 4000 && drone.creatures_scanned.length > 2 && turns > 10)
      move_x = drone.x
      move_y = 500
      drone.direction = "SURFACE"

    # comportement si des poissons sont visibles -------------------------------
    elsif visible_fishies.length > 0
      distance_to_visible_fisches = visible_fishies.map do |fish_id|
        fish = CREATURES[fish_id]
        distance = Math.sqrt((drone.x - fish.x)**2 + (drone.y - fish.y)**2)
        [fish_id, distance]
      end
      distance_to_visible_fisches.sort! do |a, b|
        a[1] <=> b[1]
      end

      closest_fish = CREATURES[distance_to_visible_fisches.first[0]]
      # des autres poissons dans in rayon de 2000
      fish_in_reach = distance_to_visible_fisches.count {|x| x[1] < 2000}

      move_x = closest_fish.x
      move_y = closest_fish.y

      # light = 1 if fish_in_reach > 0
      drone.direction = "FISH #{closest_fish.id} (#{fish_in_reach})"

    # direction a l'aveugle ----------------------------------------------------
    else
      radar = RADAR[drone_id]
      # reste a scanner
      # STDERR.puts "radar #{radar}"
      # radar { direction: [[fishies], [monsters]]}
      radar.each do |direction, creatures|
        to_search_for = creatures.select do |creature_id|
          if fishies_ids.include?(creature_id) && !found_creatures.include?(creature_id)
            creature_id
          end
        end
        to_try_avoid = creatures.select do |creature_id|
          if monsters_ids.include?(creature_id)
            creature_id
          end
        end
        radar[direction] = [to_search_for, to_try_avoid]
      end
      # STDERR.puts "radar #{radar}"

      # dans quel quart se trouve le drone
      position_in_map = ""
      if drone.y < 5000
        position_in_map = "T"
      else
        position_in_map = "B"
      end
      if drone.x < 5000
        position_in_map += "L"
      else
        position_in_map += "R"
      end
      STDERR.puts "drone position in map #{position_in_map}"
      priority_order = {
        "TL" => ["TL", "BL", "TR", "BR"],
        "BL" => ["BL", "BR", "TL", "TR"],
        "BR" => ["BR", "BL", "TR", "TL"],
        "TR" => ["TR", "BR", "TL", "BL"],
      }

      x_weight = 0
      y_weight = 0
      priority_order[position_in_map].each_with_index do |direction, index|
        weight = 2**(3 - index)
        radar[direction][0].nil? ? plus = 0 : plus = radar[direction][0].length
        radar[direction][1].nil? ? moins = 0 : moins = radar[direction][1].length
        moins = 0 if possible_scan.length <=2
        # moins = 0
        plus_weight = CREATURES.keys.length - possible_scan.length
        # plus_weight = 1

        x_weight += (plus_weight * plus - moins) * weight if direction.include?("R")
        x_weight -= (plus_weight * plus - moins) * weight if direction.include?("L")

        y_weight += (plus_weight * plus - moins) * weight if direction.include?("B")
        y_weight -= (plus_weight * plus - moins) * weight if direction.include?("T")
      end
      move_vector = {x: x_weight, y: y_weight}
      move_vector = vecteur_to_unitaire(move_vector, 1000)
      move_x = drone.x + move_vector[:x]
      move_y = drone.y + move_vector[:y]

      if move_y > 9800
        move_y = 9800
      end
      if move_x > 9500
        move_x = 9500
      elsif move_x < 500
        move_x = 500
      end

      if x_weight == 0 && y_weight == 0
        move_y = 500
      end

      drone.direction = "(#{x_weight}, #{y_weight})"
    end

    # in case of monsters nearby test avec la prediction de deplacement
    too_close = []
    visible_monsters_nearby = known_monsters.map do |monster_id|
      monster = CREATURES[monster_id]
      distance_monster_drone = Math.sqrt((drone.x - monster.x)**2 + (drone.y - monster.y)**2)
      STDERR.puts "monster #{monster_id} at #{distance_monster_drone}"
      too_close << monster_id if distance_monster_drone < 1300
      distance_monster_drone < 2000 ? monster_id : ""
    end
    visible_monsters_nearby.delete("")
    STDERR.puts "visible monsters #{visible_monsters_nearby}"

    if visible_monsters_nearby.length > 0 && drone.emergency == 0
      target = {
        x: move_x,
        y: move_y,
        distance: 1000,
        vector_x: move_x - drone.x,
        vector_y: move_y - drone.y
      }

      closest_monsters = []
      visible_monsters_nearby.each do |monster_id|
        monster = CREATURES[monster_id]
        distance_monster_drone = Math.sqrt((drone.x - monster.x)**2 + (drone.y - monster.y)**2)
        closest_monsters << [monster, distance_monster_drone] if distance_monster_drone < 2000
      end
      closest_monsters.sort! do |a, b|
        a[1] <=> b[1]
      end
      closest_monster_distance = closest_monsters.first[1]

      PROJECTIONS.each do |id, projection|
        if projection.drone == drone && projection.distance_to_drone < 1000
          closest_monsters << [projection, projection.distance_to_drone]
        end
      end

      closest_monsters.sort! do |a, b|
        a[1] <=> b[1]
      end
      closest_monsters = closest_monsters.first(3)

      if closest_monsters.length == 3 && closest_monsters.last[1] >= (closest_monsters.first[1] * 2)
        closest_monsters.delete_at(-1)
      elsif closest_monsters.length == 2
        monster_1 = closest_monsters.first[0]
        monster_2 = closest_monsters.last[0]
        angle = angle_entre_vecteurs({x: drone.x, y: drone.y}, {x: monster_1.x, y: monster_1.y}, {x: monster_2.x, y: monster_2.y})
        if angle < 20
          closest_monsters.delete_at(-1)
        end
      end
      STDERR.puts "closest monsters (#{closest_monsters.length}), dist:#{closest_monster_distance} #{closest_monsters}"
      monster_to_delete = nil
      if closest_monsters.length == 3
        closest_monsters.each_with_index do |monster, index|
          angle = angle_entre_vecteurs({x: drone.x, y: drone.y}, {x: monster[0].x, y: monster[0].y}, {x: closest_monsters[index-1][0].x, y: closest_monsters[index-1][0].y})
          if angle < 5
            if monster[1] < closest_monsters[index-1][1]
              monster_to_delete = index - 1
            else
              monster_to_delete = index
            end
          end
        end
      end
      closest_monsters.delete_at(monster_to_delete) unless monster_to_delete.nil?

      if closest_monsters.length == 2 && closest_monsters[0][0].class == closest_monsters[1][0].class
        closest_monsters.delete_at(1) if (closest_monsters[0][1] * 3 ) < closest_monsters[1][1]
      end

      closest_monsters.map! {|x| x[0]}

      STDERR.puts "target #{target}"
      vector_power = 10000

      if closest_monsters.length == 1 && closest_monsters.first.class == Creature
        monster = closest_monsters.first
        cercle_drone = {x: drone.x, y: drone.y, r: closest_monster_distance}
        cercle_monster = {x: monster.x, y: monster.y, r: closest_monster_distance}
        points = intersection_cercles(cercle_drone, cercle_monster)
        # point le plus proche de la target
        distances = []
        points.each do |point|
          distance = Math.sqrt((point[:x] - target[:x])**2 + (point[:y] - target[:y])**2)
          distances << [point, distance]
        end
        distances.sort! do |a, b|
          a[1] <=> b[1]
        end
        point = distances.first.first
        angle_point_target = angle_entre_vecteurs({x: drone.x, y: drone.y}, {x: point[:x], y: point[:y]}, {x: target[:x], y: target[:y]})
        STDERR.puts "angle point target #{angle_point_target}"
        angle_monster_target = angle_entre_vecteurs({x: drone.x, y: drone.y}, {x: monster.x, y: monster.y}, {x: target[:x], y: target[:y]})
        STDERR.puts "angle monster target #{angle_monster_target}"
        STDERR.puts "point #{point}"

        distance_monster_vecteur_point = distance_point_vecteur({x: monster.x, y: monster.y}, {x: drone.x, y: drone.y}, {x: point[:x], y: point[:y]})
        STDERR.puts "distance monster vecteur point #{distance_monster_vecteur_point}"

        # calcul du vecteur moyen entre la target et le recul du monstre
        angle_coefficient = angle_monster_target / 90
        move_x = (target[:vector_x] * angle_coefficient - closest_monsters.first.x) * 2 + drone.x
        move_y = (target[:vector_y] * angle_coefficient - closest_monsters.first.y) * 2 + drone.y
        STDERR.puts "target recalc: #{[move_x, move_y]}"

        distance_monster_vecteur_moyen = distance_point_vecteur({x: monster.x, y: monster.y}, {x: drone.x, y: drone.y}, {x: move_x, y: move_y})
        STDERR.puts "distance monster vecteur moyen #{distance_monster_vecteur_moyen}"

        if angle_point_target < 90 && closest_monster_distance > 1000 && distance_monster_vecteur_point > 600 && angle_monster_target < 90
          move_x = point[:x]
          move_y = point[:y]
        elsif distance_monster_vecteur_moyen > 1000
          move_x = (target[:vector_x] * angle_coefficient - closest_monsters.first.x) * 2 + drone.x
          move_y = (target[:vector_y] * angle_coefficient - closest_monsters.first.y) * 2 + drone.y
        else
          move_x = (drone.x - closest_monsters.first.x) * vector_power + drone.x
          move_y = (drone.y - closest_monsters.first.y) * vector_power + drone.y
        end

      elsif closest_monsters.length == 2
        if closest_monsters.last.class == Creature && closest_monsters.first.class == Creature
          monster_1 = closest_monsters.first
          monster_2 = closest_monsters.last

          # perpendiculaire a la droite
          projection = projection_ordonnee({x: drone.x, y: drone.y}, {x: monster_1.x, y: monster_1.y}, {x: monster_2.x, y: monster_2.y})
          x = projection[0]
          y = projection[1]

          projection_vector = {x: drone.x - x, y: drone.y - y}
          projection_vector[:norme] = Math.sqrt(projection_vector[:x]**2 + projection_vector[:y]**2).to_i
          STDERR.puts "projection ordonnée #{projection_vector}"
          STDERR.puts "drone direction #{drone.direction}"

          if projection_vector[:norme] < 400 && drone.direction != "SURFACE"
            if drone.y > 8000 && projection_vector[:y] < 0 && projection_vector[:y].abs < 100
              projection_vector[:x] = - projection_vector[:x]
              projection_vector[:y] = - projection_vector[:y]
            end
            STDERR.puts "projection ordonnée pas surf #{projection_vector}"
          end

          if projection_vector[:norme] < 400 && (drone.direction == "SURFACE" || drone.direction == "(0, 0)")
            if projection_vector[:y] > 0
              projection_vector[:y] = - projection_vector[:y]
            end
            dist_mmonsters = Math.sqrt((monster_1.x - monster_2.x)**2 + (monster_1.y - monster_2.y)**2)
            STDERR.puts "dist monsters:#{dist_mmonsters}"
            if dist_mmonsters > 1000
              projection_vector[:x] = 0
            else
              projection_vector[:x] = - projection_vector[:x]
            end
            STDERR.puts "projection ordonnée surf #{projection_vector}"
          end

          move_x = projection_vector[:x] * vector_power + drone.x
          move_y = projection_vector[:y] * vector_power + drone.y
          STDERR.puts "move #{[move_x, move_y]}"
          # move_x = (drone.x - x)*vector_power + drone.x
          # move_y = (drone.y - y)*vector_power + drone.y

        elsif closest_monsters.last.class != closest_monsters.first.class
          monster = 0
          drone_projection = 0
          closest_monsters.each do |entity|
            monster = entity if entity.class == Creature
            drone_projection = entity if entity.class == Projection
          end

          # perpendiculaire a la droite
          projection = projection_ordonnee({x: drone.x, y: drone.y}, {x: monster.x, y: monster.y}, {x: drone_projection.x, y: drone_projection.y})
          x = projection[0]
          y = projection[1]
          STDERR.puts "projection ordonnée #{x}, #{y}"
          projection_vector = {x: drone.x - x, y: drone.y - y}
          projection_vector[:norme] = Math.sqrt(projection_vector[:x]**2 + projection_vector[:y]**2).to_i
          STDERR.puts "projection ordonnée #{projection_vector}"
          STDERR.puts "drone direction #{drone.direction}"

          if projection_vector[:norme] < 200
            if drone.direction == "SURFACE" || drone.direction == "(0, 0)"
              if projection_vector[:y] > 0
                projection_vector[:x] = - projection_vector[:x]
                projection_vector[:y] = - projection_vector[:y]
                STDERR.puts "projection ordonnée pas surf #{projection_vector}"
              end
            else
              condition_1 = drone.y > 7500 && projection_vector[:y] < 0
              condition_2 = drone.y < 6500 && projection_vector[:y] < 0 && y_weight > 0
              condition_3 = drone.x < 2500 && projection_vector[:x] < 0
              condition_4 = drone.x > 7500 && projection_vector[:x] > 0
              if condition_1 || condition_2 || condition_3 || condition_4
                projection_vector[:x] = - projection_vector[:x]
                projection_vector[:y] = - projection_vector[:y]
                STDERR.puts "projection ordonnée surf #{projection_vector}"
              end
            end
          end

          # if projection_vector[:norme] < 400 && drone.direction != "SURFACE"
          #   if drone.y > 7500 && projection_vector[:y] < 0
          #     projection_vector[:x] = - projection_vector[:x]
          #     projection_vector[:y] = - projection_vector[:y]
          #     STDERR.puts "je suis ici 1#{projection_vector}"
          #   elsif drone.y < 6500 && projection_vector[:y] < 0 && y_weight > 0
          #     projection_vector[:x] = - projection_vector[:x]
          #     projection_vector[:y] = - projection_vector[:y]
          #     STDERR.puts "je suis ici 2#{projection_vector}"
          #   elsif drone.x < 2500 && projection_vector[:x] < 0
          #     projection_vector[:x] = - projection_vector[:x]
          #   elsif drone.x > 7500 && projection_vector[:x] > 0
          #     projection_vector[:x] = - projection_vector[:x]
          #   end

          #   STDERR.puts "projection ordonnée pas surf #{projection_vector}"
          # end

          # if projection_vector[:norme] < 400 && (drone.direction == "SURFACE" || drone.direction == "(0, 0)")
          #   if projection_vector[:y] > 0
          #     projection_vector[:y] = - projection_vector[:y]
          #   end
          #   STDERR.puts "monster x :#{monster.x}"
          #   if monster.x > 1000 || monster.x < 9000
          #     projection_vector[:x] = 0
          #   else
          #     projection_vector[:x] = - projection_vector[:x]
          #   end
          #   STDERR.puts "projection ordonnée surf #{projection_vector}"
          # end

          move_x = projection_vector[:x] * vector_power + drone.x
          move_y = projection_vector[:y] * vector_power + drone.y
          STDERR.puts "move #{[move_x, move_y]}"
        else
          drone.direction = "NEAR BORDERS"
        end

      else
        monster_1 = closest_monsters[0]
        monster_2 = closest_monsters[1]
        monster_3 = closest_monsters[2]

        # drone dans triangle de monstre ?
        dans_triangle = point_dans_triangle({x: monster_1.x, y: monster_1.y}, {x: monster_2.x, y: monster_2.y}, {x: monster_3.x, y: monster_3.y}, {x: drone.x, y: drone.y})
        STDERR.puts "dans triangle? #{dans_triangle}"
        if dans_triangle == true
          distance_1_2 = Math.sqrt((monster_1.x - monster_2.x)**2 + (monster_1.y - monster_2.y)**2)
          distance_1_3 = Math.sqrt((monster_1.x - monster_3.x)**2 + (monster_1.y - monster_3.y)**2)
          distance_2_3 = Math.sqrt((monster_2.x - monster_3.x)**2 + (monster_2.y - monster_3.y)**2)

          if distance_1_2 > distance_1_3 && distance_1_2 > distance_2_3
            projection = projection_ordonnee({x: monster_3.x, y: monster_3.y}, {x: monster_1.x, y: monster_1.y}, {x: monster_2.x, y: monster_2.y})
            x = projection[0]
            y = projection[1]
            monster = monster_3
          elsif distance_1_3 > distance_1_2 && distance_1_3 > distance_2_3
            projection = projection_ordonnee({x: monster_2.x, y: monster_2.y}, {x: monster_3.x, y: monster_3.y}, {x: monster_1.x, y: monster_1.y})
            x = projection[0]
            y = projection[1]
            monster = monster_2
          elsif distance_2_3 > distance_1_2 && distance_2_3 > distance_1_3
            projection = projection_ordonnee({x: monster_1.x, y: monster_1.y}, {x: monster_2.x, y: monster_2.y}, {x: monster_3.x, y: monster_3.y})
            x = projection[0]
            y = projection[1]
            monster = monster_1
          end

          move_x = (x - monster.x)*vector_power + drone.x
          move_y = (y - monster.y)*vector_power + drone.y

        else

          distance_1_2 = distance_point_vecteur({x: drone.x, y: drone.y}, {x: monster_1.x, y: monster_1.y}, {x: monster_2.x, y: monster_2.y})
          distance_1_3 = distance_point_vecteur({x: drone.x, y: drone.y}, {x: monster_1.x, y: monster_1.y}, {x: monster_3.x, y: monster_3.y})
          distance_2_3 = distance_point_vecteur({x: drone.x, y: drone.y}, {x: monster_3.x, y: monster_3.y}, {x: monster_2.x, y: monster_2.y})

          STDERR.puts "distances: #{[distance_1_2, distance_1_3, distance_2_3]}"
          if distance_1_2 < distance_1_3 && distance_1_2 < distance_2_3
            x = (monster_1.x - monster_2.x) / 2 + monster_2.x
            y = (monster_1.y - monster_2.y) / 2 + monster_2.y
            monster = monster_3
            STDERR.puts "milieu droite #{monster_1.id} #{monster_2.id} #{[x, y]} #{monster.id}"
          elsif distance_1_3 < distance_1_2 && distance_1_3 < distance_2_3
            x = (monster_1.x - monster_3.x) / 2 + monster_3.x
            y = (monster_1.y - monster_3.y) / 2 + monster_3.y
            monster = monster_2
            STDERR.puts "milieu droite #{monster_1.id} #{monster_3.id} #{[x, y]} #{monster.id}"
          elsif distance_2_3 < distance_1_2 && distance_2_3 < distance_1_3
            x = (monster_3.x - monster_2.x) / 2 + monster_2.x
            y = (monster_3.y - monster_2.y) / 2 + monster_2.y
            monster = monster_1
            STDERR.puts "milieu droite #{monster_3.id} #{monster_2.id} #{[x, y]} #{monster.id}"
          end
          STDERR.puts "milieu droite #{[x, y]} #{[monster.x, monster.y]}"
          STDERR.puts "#{[x-monster.x, y-monster.y]}"
          # vector_power fois depuis la projection a la droite monstre
          move_x = (x - monster.x)*vector_power + drone.x
          move_y = (y - monster.y)*vector_power + drone.y
        end
        # projection de monstre 3 sur la droite de monstre 1 et 2
        # projection = projection_ordonnee({x: monster_3.x, y: monster_3.y}, {x: monster_1.x, y: monster_1.y}, {x: monster_2.x, y: monster_2.y})
        # x = projection[0]
        # y = projection[1]

        # # vector_power fois depuis la projection a la droite monstre
        # move_x = (x - drone.x)*vector_power + drone.x
        # move_y = (y - drone.y)*vector_power + drone.y
      end
      # turns % 2 == 0 ? light = 1 : light = 0
      drone.direction = "RETREAT"
      drone.avoid_monster_vector[:x] = move_x - drone.x
      drone.avoid_monster_vector[:y] = move_y - drone.y
      puts "MOVE #{move_x} #{move_y} #{light} #{drone.id} #{light == 1 ? "ON" : "OFF"} #{drone.direction} (#{closest_monsters.length})"
      drone.directions_archives << drone.direction
    else # pas de monstres visibles
      drone.direction = "EMERGENCY" if drone.emergency == 1
      light = 0 if drone.emergency == 1
      puts "MOVE #{move_x} #{move_y} #{light} #{drone.id} #{light == 1 ? "ON" : "OFF"} TO #{drone.direction}"
      drone.directions_archives << drone.direction
    end
    drone.ligths_on = light
  end
end
