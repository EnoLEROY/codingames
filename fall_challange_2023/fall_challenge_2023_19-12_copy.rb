STDOUT.sync = true # DO NOT REMOVE
# Score points by scanning valuable fish faster than your opponent.

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

  angle = Math.acos(produit_vectoriel/produit_longueurs)
  angle_deg = angle * 180/Math::PI
  angle_deg = 1000 if angle_deg.nan?
  return angle_deg.to_i
end

class Creature
  attr_accessor :id, :color, :type, :x, :y, :vx, :vy, :scanned, :localisation_by_radar, :distance_to_drone, :last_update
  def initialize(attrs)
    @id = attrs[:id]
    @color = attrs[:color]
    @type = attrs[:type]
    @x = attrs[:x] || nil
    @y = attrs[:y] || nil
    @vx = attrs[:vx] || nil
    @vy = attrs[:vy] || nil
    @scanned = false
    @localisation_by_radar = [] # [drone, localisation]
    @distance_to_drone = nil
    @last_update = 0
  end
end

class Drone
  attr_accessor :id, :owner, :x, :y, :emergency, :battery, :direction, :directions_archives, :creatures_scanned, :target_creature, :avoid_monster_vector
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
    STDERR.puts "drone #{drone_id}: batterie: #{drone.battery}"
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
    STDERR.puts "drone #{id} scanned: #{drone.creatures_scanned}"
  end
  found_creatures.flatten!.uniq!
  STDERR.puts "creatures found: #{found_creatures}"

  # prediction des emplacements des creatures
  CREATURES.each do |id, creature|
    creature.last_update += 1
    if !creature.vx.nil?
      creature.x += creature.vx
      creature.vx = nil
      creature.y += creature.vy
      creature.vy = nil
      creature.last_update = 0
    elsif creature.last_update > 2
      creature.x = nil
      creature.y = nil
    end
  end

  # resset des x y des crétures
  # CREATURES.each do |id, creature|
  #   creature.x = nil if monsters_ids.include?(id)
  #   creature.y = nil if monsters_ids.include?(id)
  # end

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
    visible_creatures << creature_id
  end
  STDERR.puts "visible creatures: #{visible_creatures}"

  # scanned = []
  # CREATURES.each do |id, creature|
  #   scanned << id if creature.scanned == true
  # end

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

  MY_DRONES.each do |drone_id, drone|
    # etat des light par default
    STDERR.puts "-- infos drone #{drone_id} --"
    turns += 1
    drone.battery < 15 ? light_frequance = 4 : light_frequance = 3
    turns % light_frequance == 0 ? light = 1 : light = 0

    if drone.creatures_scanned.length > 4 || possible_scan == 0 || (drone.direction == "SURFACE" && drone.creatures_scanned.length > 0) || (drone.y < 3000 && drone.creatures_scanned.length > 2)
      move_x = drone.x
      move_y = 500
      drone.direction = "SURFACE"
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

      light = 1 if fish_in_reach > 0
      drone.direction = "FISH #{closest_fish.id} (#{fish_in_reach})"

    else # direction a l'aveugle
      radar = RADAR[drone_id]
      # reste a scanner
      # STDERR.puts "radar #{radar}"
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

      # pas de direction correct donne la direction dans la quelle il est
      # if !priority_order.keys.include?(drone.direction)
      #   drone.direction = priority_order[position_in_map].first
      # end

      # par default cherche dans sont cadrant
      # drone.direction = priority_order[position_in_map].first

      # if radar[drone.direction].length == 0  # la direction ne contient plus de poissons a scanner
      #   possible_directions = priority_order[position_in_map].select do |direction|
      #     direction if radar[direction].length > 0
      #   end
      #   drone.direction = possible_directions.first
      # end
      x_weight = 0
      y_weight = 0
      priority_order[position_in_map].each_with_index do |direction, index|
        weight = (4 - index) * 2
        radar[direction][0].nil? ? plus = 0 : plus = radar[direction][0].length
        radar[direction][1].nil? ? moins = 0 : moins = radar[direction][1].length
        moins = 0 if possible_scan.length <=2
        plus_weight = CREATURES.keys.length - possible_scan.length
        x_weight += (plus_weight * plus - moins) * weight if direction.include?("R")
        x_weight -= (plus_weight * plus - moins) * weight if direction.include?("L")

        y_weight += (plus_weight * plus - moins) * weight if direction.include?("B")
        y_weight -= (plus_weight * plus - moins) * weight if direction.include?("T")
      end
      move_x = drone.x + x_weight * 1000
      move_y = drone.y + y_weight * 1000
      if x_weight == 0 && y_weight == 0
        move_y = 500
      end
      angle = angle_entre_vecteurs({x: drone.x, y: drone.y}, {x: move_x, y: move_y}, {x: drone.avoid_monster_vector[:x], y: drone.avoid_monster_vector[:y]})
      # if angle < 200
      #   move_x -= drone.avoid_monster_vector[:y]
      #   move_y += drone.avoid_monster_vector[:x]
      # end

      drone.direction = "(#{x_weight}, #{y_weight}, #{angle})"
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

    if visible_monsters_nearby.length > 0
      target = {
        x: move_x,
        y: move_y,
        distance: Math.sqrt((move_x - drone.x)**2 + (move_y - drone.y)**2),
        vector_x: move_x - drone.x,
        vector_y: move_y - drone.y
      }
      best_exit = { distance_to_target: 10000 }

      possible_escape_points = []
      closest_monsters = []
      visible_monsters_nearby.each do |monster_id|
        monster = CREATURES[monster_id]
        distance_monster_drone = Math.sqrt((drone.x - monster.x)**2 + (drone.y - monster.y)**2)
        closest_monsters << [monster, distance_monster_drone] if distance_monster_drone < 2000
        cercle_drone = {x: drone.x, y: drone.y, r: distance_monster_drone}
        cercle_monster = {x: monster.x, y: monster.y, r: distance_monster_drone}
        points = intersection_cercles(cercle_drone, cercle_monster)

        points.each do |point|
          point[:distance] = distance_monster_drone.to_i
          point[:monster_id] = monster_id
          angle_target_point = angle_entre_vecteurs({x: drone.x, y: drone.y}, {x: point[:x], y: point[:y]}, {x: target[:x], y: target[:y]})
          out_of_map = (point[:x] < 0 || point[:x] > 10000 || point[:y] < 0 || point[:y] > 10000)

          if distance_monster_drone > 1000 && angle_target_point < 45
            possible_escape_points << point unless out_of_map
          end
        end
      end
      possible_escape_points.flatten!
      STDERR.puts "escape points(#{possible_escape_points.length}): #{possible_escape_points}"


      possible_escape_points.each do |possibility|
        distance_target = Math.sqrt((possibility[:x] - target[:x])**2 + (possibility[:y] - target[:y])**2)
        # distance aux autres monstres
        visible_monsters_nearby.each do |monster_id|
          monster = CREATURES[monster_id]
          distance_possibility_monster = distance_point_vecteur({x: monster.x, y: monster.y}, {x: drone.x, y: drone.y}, possibility)
          possibility[:veto] = 1 if distance_possibility_monster < 1000
        end

        if distance_target < best_exit[:distance_to_target] && possibility[:veto].nil?
          best_exit = {x: possibility[:x], y: possibility[:y], distance_to_target: distance_target}
        end
      end

      STDERR.puts "exit point: #{best_exit}"

      if best_exit[:distance_to_target] == 10000 || too_close.length > 0 # pas de bonne exit trouvée
        # [Monster, distance]
        closest_monsters.sort! do |a, b|
          a[1] <=> b[1]
        end
        closest_monsters = closest_monsters.first(3)
        # exit perpendiculaire aux deux plus proches et opposé au 3 eme si dans un rayon de 2500
        # proche d'un mur

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
        STDERR.puts "closest monsters #{closest_monsters.length}"
        STDERR.puts "closest monsters #{closest_monsters}"
        closest_monsters.map! {|x| x[0]}

        closest_projection = []
        PROJECTIONS.each do |id, projection|
          if projection.drone == drone && projection.distance_to_drone < 1000
            closest_projection << [projection, projection.distance_to_drone]
          end
        end

        if closest_projection.length > 0
          closest_projection.sort! do |a, b|
            a[1] <=> b[1]
          end
          closest_monsters = [closest_monsters.first, closest_projection.first.first]
        end

        STDERR.puts "closest monsters #{closest_monsters.length}"
        STDERR.puts "closest monsters #{closest_monsters}}"
        vector_power = 10000

        if closest_monsters.length == 1
          move_x = (drone.x - closest_monsters.first.x)*2 + drone.x
          move_y = (drone.y - closest_monsters.first.y)*2 + drone.y
        elsif closest_monsters.length == 2
          monster_1 = closest_monsters.first
          monster_2 = closest_monsters.last
          # centre de la droite
          # x = (monster_1.x - monster_2.x) / 2 + monster_2.x
          # y = (monster_1.y - monster_2.y) / 2 + monster_2.y

          # perpendiculaire a la droite
          projection = projection_ordonnee({x: drone.x, y: drone.y}, {x: monster_1.x, y: monster_1.y}, {x: monster_2.x, y: monster_2.y})
          x = projection[0]
          y = projection[1]
          move_x = (drone.x - x)*vector_power + drone.x
          move_y = (drone.y - y)*vector_power + drone.y

          vector_target_power = 180 - angle_entre_vecteurs({x: drone.x, y: drone.y}, {x: move_x, y: move_y}, {x: target[:x], y: target[:y]})
          # vector_power fois depuis la projection a la droite monstre
          move_x = (drone.x - x)*vector_power + drone.x + target[:vector_x] * vector_target_power
          move_y = (drone.y - y)*vector_power + drone.y + target[:vector_y] * vector_target_power
        else
          monster_1 = closest_monsters[0]
          monster_2 = closest_monsters[1]
          monster_3 = closest_monsters[2]
          # projection de monstre 3 sur la droite de monstre 1 et 2
          projection = projection_ordonnee({x: monster_3.x, y: monster_3.y}, {x: monster_1.x, y: monster_1.y}, {x: monster_2.x, y: monster_2.y})
          x = projection[0]
          y = projection[1]
          move_x = (drone.x - x)*vector_power + drone.x
          move_y = (drone.y - y)*vector_power + drone.y

          vector_target_power = 180 - angle_entre_vecteurs({x: drone.x, y: drone.y}, {x: move_x, y: move_y}, {x: target[:x], y: target[:y]})
          # vector_power fois depuis la projection a la droite monstre
          move_x = (drone.x - x)*vector_power + drone.x + target[:vector_x] * vector_target_power
          move_y = (drone.y - y)*vector_power + drone.y + target[:vector_y] * vector_target_power
        end
        # turns % 2 == 0 ? light = 1 : light = 0
        drone.direction = "RETREAT"
        drone.avoid_monster_vector[:x] = move_x - drone.x
        drone.avoid_monster_vector[:y] = move_y - drone.y
        puts "MOVE #{move_x} #{move_y} #{light} #{drone.id} #{light == 1 ? "ON" : "OFF"} #{drone.direction} (#{closest_monsters.length})"
        drone.directions_archives << drone.direction
      else
        drone.direction = "AVOID"
        drone.avoid_monster_vector[:x] = move_x - drone.x
        drone.avoid_monster_vector[:y] = move_y - drone.y
        puts "MOVE #{best_exit[:x].to_i} #{best_exit[:y].to_i} #{light} #{drone.id} #{light == 1 ? "ON" : "OFF"} #{drone.direction}"
        drone.directions_archives << drone.direction
      end
    else # pas de monstres visibles
      light = 0 if drone.emergency == 1
      puts "MOVE #{move_x} #{move_y} #{light} #{drone.id} #{light == 1 ? "ON" : "OFF"} TO #{drone.direction}"
      drone.directions_archives << drone.direction
    end
  end
end
