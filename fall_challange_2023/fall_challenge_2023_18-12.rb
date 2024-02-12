STDOUT.sync = true # DO NOT REMOVE
# Score points by scanning valuable fish faster than your opponent.

def intersection_cercles(cercle_a, cercle_b)
  # cercle_a = { x: 22, y: 30, r: 20 }
  # cercle_b = { x: 30, y: 60, r: 20 }
  g = { x: 0, y: 0 }
  h = { x: 0, y: 0 }

  a = 2 * (cercle_b[:x]-cercle_a[:x])
  b = 2 * (cercle_b[:y]-cercle_a[:y])
  c = (cercle_b[:x]-cercle_a[:x])**2 + (cercle_b[:y]-cercle_a[:y])**2 - cercle_b[:r]**2 + cercle_a[:r]**2

  delta = (2*a*c)**2 - 4*(a**2+b**2)*(c**2-b**2*cercle_a[:r]**2)

  g[:x] = cercle_a[:x] + (2*a*c-Math.sqrt(delta))/(2*(a**2+b**2))
  h[:x] = cercle_a[:x] + (2*a*c+Math.sqrt(delta))/(2*(a**2+b**2))

  if b == 0
    g[:y] = cercle_a[:y] + b/2 + Math.sqrt(cercle_b[:r]**2 - ((2*c-a**2)/(2*a))**2)
    h[:y] = cercle_a[:y] + b/2 - Math.sqrt(cercle_b[:r]**2 - ((2*c-a**2)/(2*a))**2)
  else
    g[:y] = cercle_a[:y] + (c-a*(g[:x]-cercle_a[:x]))/b
    h[:y] = cercle_a[:y] + (c-a*(h[:x]-cercle_a[:x]))/b
  end
  return [g, h]
end

class Creature
  attr_accessor :id, :color, :type, :x, :y, :vx, :vy, :scanned, :localisation_by_radar, :distance_to_drone
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
  end
end

class Drone
  attr_accessor :id, :owner, :x, :y, :emergency, :battery, :direction, :creatures_scanned
  def initialize(attrs)
    @id = attrs[:id]
    @owner = attrs[:owner]
    @x = attrs[:x]
    @y = attrs[:y]
    @emergency = attrs[:emergency]
    @battery = attrs[:battery]
    @direction = nil
    @creatures_scanned = []
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

turns = 0
# game loop
loop do
  turns += 1
  aggressiv_creatures_ids = CREATURES.values.select {|x| x.type == -1}
  aggressiv_creatures_ids.map! {|x| x.id}
  # STDERR.puts "aggressi creatures #{aggressiv_creatures_ids}"
  passiv_creatures_ids = CREATURES.values.select {|x| x.type != -1}
  passiv_creatures_ids.map! {|x| x.id}
  my_score = gets.to_i
  foe_score = gets.to_i
  my_scan_count = gets.to_i
  saved = []
  my_scan_count.times do
    creature_id = gets.to_i
    # CREATURES[creature_id].scanned = true
    saved << creature_id
  end
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
      DRONES[drone_id].battery = battery
    end
  end

  drone_scan_count = gets.to_i
  drone_scan_count.times do
    drone_id, creature_id = gets.split.map { |x| x.to_i }
    CREATURES[creature_id].scanned = true if MY_DRONES.keys.include?(drone_id)
    MY_DRONES[drone_id].creatures_scanned << creature_id if MY_DRONES.keys.include?(drone_id)
    # STDERR.puts "#{MY_DRONES[drone_id].creatures_scanned}" if MY_DRONES.keys.include?(drone_id)
    MY_DRONES[drone_id].creatures_scanned.uniq! if MY_DRONES.keys.include?(drone_id)
    # STDERR.puts "drone scan count : drone #{drone_id}, creature #{creature_id}"
  end

  CREATURES.each do |id, creature|
    if aggressiv_creatures_ids.include?(id)
      creature.x = nil
      creature.y = nil
    end
  end

  visible_creature_count = gets.to_i
  visible_creature_count.times do
    creature_id, creature_x, creature_y, creature_vx, creature_vy = gets.split.map { |x| x.to_i }
    # STDERR.puts "visible #{creature_id}"
    CREATURES[creature_id].x = creature_x
    CREATURES[creature_id].y = creature_y
    CREATURES[creature_id].vx = creature_vx
    CREATURES[creature_id].vy = creature_vy
  end

  scanned = []
  CREATURES.each do |id, creature|
    scanned << id if creature.scanned == true
  end

  radar_blip_count = gets.to_i
  radar_blip_count.times do
    drone_id, creature_id, radar = gets.split
    # STDERR.puts "radar : #{radar}"
    drone_id = drone_id.to_i
    creature_id = creature_id.to_i
    CREATURES[creature_id].localisation_by_radar = [drone_id, radar]
    RADAR[drone_id][radar] << creature_id unless scanned.include?(creature_id)
    # STDERR.puts "#{RADAR[drone_id][radar]}"
    # RADAR[drone_id][radar].uniq!
  end
  # STDERR.puts "#{RADAR}"

  to_scan = [] # id, x, y
  to_avoid = [] # id, x, y
  CREATURES.each do |id, creature|
    if creature.scanned == false
      to_scan << [id, creature.x, creature.y, creature] unless (creature.x.nil? || aggressiv_creatures_ids.include?(id))
      to_avoid << creature unless (creature.x.nil? || !aggressiv_creatures_ids.include?(id))
    end
  end
  # STDERR.puts "to_scan #{to_scan}"
  # pour chaque drone
  # STDERR.puts "drones #{MY_DRONES.length}"



  MY_DRONES.each do |drone_id, drone|
    STDERR.puts "actions pour drone #{drone.id}"
    move_x = drone.x
    move_y = 450
    light = 0
    # on prend tous les non scannés et on prend drone_id et distance au drone
    # scannées non enregistrées
    not_saved = drone.creatures_scanned.select {|creature_id| !saved.include?(creature_id)}
    STDERR.puts "not saved #{not_saved}"
    if not_saved.length > 2 || scanned.length == passiv_creatures_ids.length
      move_x = drone.x
      move_y = 450
      light = turns % 2
      direction = "SURFACE"
    elsif to_scan.length > 0
      to_sort = to_scan.map do |creature|
        # STDERR.puts "#{creature[0]} #{drone.x}, #{drone.y}, #{creature[1]}, #{creature[2]}"
        distance = Math.sqrt((drone.x - creature[1])**2 + (drone.y - creature[2])**2)
        [creature[0], distance]
      end
      to_sort.sort! do |a, b|
        a[1] <=> b[1]
      end
      STDERR.puts "sorted#{to_sort}"

      goal_creature = CREATURES[to_sort.first[0]]
      distance = to_sort.first[1]

      move_x = goal_creature.x
      move_y = goal_creature.y

      to_light_distance = []
      to_sort.each do |x|
        to_light_distance << 1 if x[1] < 2100
      end

      # allumage de la lampe
      to_light_distance.length > 0 ? light = 1 : light = 0
      # on sort par rapport a la distance et on resort l'drone_id pour avoir les coords de la creature
      # si elle est a plus de 2000u = eteint les lampes sinon full lampe

      # puts "WAIT 1" # MOVE <x> <y> <light (1|0)> | WAIT <light (1|0)>
    else
      creature_in_direction = []
      creature_in_direction = RADAR[drone_id][drone.direction] unless RADAR[drone_id][drone.direction].nil?
      if creature_in_direction.length == 0
        max_creatures = RADAR[drone_id].values.map {|x| x.length}
        # STDERR.puts "max creatures #{max_creatures}"
        max_creatures.delete(0)
        # STDERR.puts "max creatures #{max_creatures}"
        max_creatures = max_creatures.max
        # STDERR.puts "max creatures #{max_creatures}"
        go_to = RADAR[drone_id].select do |direction, creature_ids|
          creature_ids.length == max_creatures
        end
        # STDERR.puts "go_to #{go_to}"
        direction = go_to.keys.first
        drone.direction = direction
      else
        direction = drone.direction
      end

      case direction
      when "TL"
        move_x = drone.x - 2000
        move_y = drone.y - 2000
      when "TR"
        move_x = drone.x + 2000
        move_y = drone.y - 2000
      when "BL"
        move_x = drone.x - 2000
        move_y = drone.y + 2000
      when "BR"
        move_x = drone.x + 2000
        move_y = drone.y + 2000
      end
      light = turns % 2
    end

    # STDERR.puts "to avoid #{to_avoid}"

    avoid = to_avoid.map do |creature|
      distance = Math.sqrt((drone.x - creature.x)**2 + (drone.y - creature.y)**2)
      creature.distance_to_drone = distance.to_i
      # STDERR.puts creature.distance_to_drone
      creature
    end
    # STDERR.puts "avoid #{avoid.each {|x| x.id}}"
    radius = 2000

    avoid.select! do |creature|
      # STDERR.puts "creature #{creature}"
      # STDERR.puts "select #{creature.distance_to_drone}"
      creature.distance_to_drone < radius + 200
    end
    avoid.sort! do |a, b|
      a.distance_to_drone <=> b.distance_to_drone
    end

    STDERR.puts "AVOID:"
    STDERR.puts avoid


    if avoid.length > 0
      light = 0
      # trouver le point optimal pour eviter les monstres

      farthest_from_threat = {
        possiblities: [],
        distance_min_from_threat: 0
      }
      # ranges avec incrementations de 10
      increment = 10
      case direction
      when "TL"
        range_x = (((drone.x - radius) / increment)..((drone.x) / increment)).to_a
        range_y = (((drone.y - radius) / increment)..((drone.y) / increment)).to_a
      when "TR"
        range_x = (((drone.x) / increment)..((drone.x + radius) / increment)).to_a
        range_y = (((drone.y - radius) / increment)..((drone.y) / increment)).to_a
      when "BL"
        range_x = (((drone.x - radius) / increment)..((drone.x) / increment)).to_a
        range_y = (((drone.y) / increment)..((drone.y + radius) / increment)).to_a
      when "BR"
        range_x = (((drone.x) / increment)..((drone.x + radius) / increment)).to_a
        range_y = (((drone.y) / increment)..((drone.y + radius) / increment)).to_a
      end


      # STDERR.puts "ranges"
      # STDERR.puts "#{range_x},\n#{range_y}"
      points_on_circle = []
      for x in range_x.map! {|x| x*increment}
        for y in range_y.map! {|y| y*increment}
          # on_circle = ((x - drone.x)**2 + (y - drone.y)**2 <= (radius**2 + (increment)) && (x - drone.x)**2 + (y - drone.y)**2 >= (radius**2  - (increment)))
          on_circle = (x - drone.x)**2 + (y - drone.y)**2 == radius**2
          if on_circle
            distances = []
            points_on_circle << {x: x, y: y}
            avoid.each do |monster|
              distance = Math.sqrt((x - monster.x)**2 + (y - monster.y)**2)
              distances << distance
            end

            distance_min = distances.sort!.first
            # STDERR.puts "distances"
            # STDERR.puts "#{distances}"
            # STDERR.puts distance_min
            # STDERR.puts farthest_from_threat[:distance_min_from_threat]
            if distance_min > (radius / 2)
              farthest_from_threat[:distance_min_from_threat] = distance_min if farthest_from_threat[:distance_min_from_threat] <= distance_min
              farthest_from_threat[:possiblities] << {x: x, y: y}
            end
          end
        end
      end
      STDERR.puts "points on circle: #{points_on_circle.length}"
      STDERR.puts "farthest possiblities: #{farthest_from_threat[:possiblities].length}"

      target = {
        x: move_x,
        y: move_y,
        distance: Math.sqrt((move_x - drone.x)**2 + (move_y - drone.y)**2)
      }

      closest_to_target = {
        x: move_x,
        y: move_y,
        distance: Math.sqrt((move_x - drone.x)**2 + (move_y - drone.y)**2)
      }
      farthest_from_threat[:possiblities].each do |possiblity|
        distance = Math.sqrt((possiblity[:x] - target[:x])**2 + (possiblity[:y] - target[:y])**2)
        if distance < closest_to_target[:distance_to_target]
          closest_to_target = {x: possiblity[:x], y: possiblity[:y], distance_to_target: distance}
        end
      end
      STDERR.puts "target #{target}"
      STDERR.puts "closest target #{closest_to_target}"

      puts "MOVE #{closest_to_target[:x]} #{closest_to_target[:y]} #{light} #{drone.id} AVOID!"
    else
      puts "MOVE #{move_x} #{move_y} #{light} #{drone.id} GOING FOR #{direction}"
    end
  end
end
