STDOUT.sync = true # DO NOT REMOVE
# Auto-generated code below aims at helping you parse
# the standard input according to the problem statement.

# fonctions --------------------------------------------------
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



# classes --------------------------------------------------
class Entity
  attr_accessor :id, :type, :shield_life, :is_controlled, :health, :x, :y, :vx, :vy, :near_base, :threat_for
  def initialize(attrs)
    @id = attrs[:id]
    @type = attrs[:type]
    @shield_life = attrs[:shield_life]
    @is_controlled = attrs[:is_controlled]
    @health = attrs[:health]
    @x = attrs[:x]
    @y = attrs[:y]
    @vx = attrs[:vx]
    @vy = attrs[:vy]
    @near_base = attrs[:near_base]
    @threat_for = attrs[:threat_for]
  end
end

class Monster < Entity
  attr_accessor :dead
  def initialize(attrs)
    super
    @dead = false
  end
end

class Hero < Entity
  attr_accessor :action, :target, :distance_to_target
  def initialize(attrs)
    super
    @action = nil
    @target = nil
    @distance_to_target = nil
  end
end


# base_x: The corner of the map representing your base
base_x, base_y = gets.split.map { |x| x.to_i }
STDERR.puts "base #{[base_x, base_y]}"
heroes_per_player = gets.to_i # Always 3
# base_positions_for_heroes = [[1000, 1000], [3000, 5000], [5000, 3000]] if base_y == 0
base_positions = [[2000, 6500], [6500, 2000], [5500, 5000]]
base_positions_for_heroes = base_positions if base_y == 0
base_positions_for_heroes = base_positions.map {|x| [17630 - x[0], 9000 - x[1]]} if base_y == 9000

map_center = [17630 / 2, 9000 / 2]

FOE_HEROES = {}
MY_HEROES = {}
MONSTERS = {}
# game loop
loop do
  2.times do
    # health: Each player's base health
    # mana: Ignore in the first league; Spend ten mana to cast a spell
    health, mana = gets.split.map { |x| x.to_i }
  end

  monsters_alive = []
  entity_count = gets.to_i # Amount of heros and monsters you can see
  entity_count.times do
    # id: Unique identifier
    # type: 0=monster, 1=your hero, 2=opponent hero
    # x: Position of this entity
    # shield_life: Ignore for this league; Count down until shield spell fades
    # is_controlled: Ignore for this league; Equals 1 when this entity is under a control spell
    # health: Remaining health of this monster
    # vx: Trajectory of this monster
    # near_base: 0=monster with no target yet, 1=monster targeting a base
    # threat_for: Given this monster's trajectory, is it a threat to 1=your base, 2=your opponent's base, 0=neither
    id, type, x, y, shield_life, is_controlled, health, vx, vy, near_base, threat_for = gets.split.map { |x| x.to_i }
    STDERR.puts "entity #{[id, type, x, y, shield_life, is_controlled, health, vx, vy, near_base, threat_for]}"
    if type == 0
      # monsters
      monsters_alive << id
      if MONSTERS[id].nil?
        monster = Monster.new({
          id: id,
          type: type,
          x: x,
          y: y,
          shield_life: shield_life,
          is_controlled: is_controlled,
          health: health,
          vx: vx,
          vy: vy,
          near_base: near_base,
          threat_for: threat_for
        })
        MONSTERS[id] = monster
      else
        MONSTERS[id].x = x
        MONSTERS[id].y = y
        MONSTERS[id].shield_life = shield_life
        MONSTERS[id].is_controlled = is_controlled
        MONSTERS[id].health = health
        MONSTERS[id].vx = vx
        MONSTERS[id].vy = vy
        MONSTERS[id].near_base = near_base
        MONSTERS[id].threat_for = threat_for
      end
    elsif type == 1
      if MY_HEROES[id].nil?
        hero = Hero.new({
          id: id,
          type: type,
          x: x,
          y: y,
          shield_life: shield_life,
          is_controlled: is_controlled,
          health: health,
          vx: vx,
          vy: vy,
          near_base: near_base,
          threat_for: threat_for
        })
        MY_HEROES[id] = hero
      else
        MY_HEROES[id].x = x
        MY_HEROES[id].y = y
        MY_HEROES[id].shield_life = shield_life
        MY_HEROES[id].is_controlled = is_controlled
        MY_HEROES[id].health = health
        MY_HEROES[id].vx = vx
        MY_HEROES[id].vy = vy
        MY_HEROES[id].near_base = near_base
        MY_HEROES[id].threat_for = threat_for
      end
    elsif type == 2
      if FOE_HEROES[id].nil?
        hero = Hero.new({
          id: id,
          type: type,
          x: x,
          y: y,
          shield_life: shield_life,
          is_controlled: is_controlled,
          health: health,
          vx: vx,
          vy: vy,
          near_base: near_base,
          threat_for: threat_for
        })
        FOE_HEROES[id] = hero
      else
        FOE_HEROES[id].x = x
        FOE_HEROES[id].y = y
        FOE_HEROES[id].shield_life = shield_life
        FOE_HEROES[id].is_controlled = is_controlled
        FOE_HEROES[id].health = health
        FOE_HEROES[id].vx = vx
        FOE_HEROES[id].vy = vy
        FOE_HEROES[id].near_base = near_base
        FOE_HEROES[id].threat_for = threat_for
      end
    end
  end
  MONSTERS.delete_if do |monster_id, monster|
    !monsters_alive.include?(monster_id)
  end
  STDERR.puts "monster #{MONSTERS}"

  targets = []
  MY_HEROES.each do |hero_id, hero|
    index = MY_HEROES.keys.index(hero.id)
    base_hero_position = base_positions_for_heroes[index]

    monsters_distances = []
    MONSTERS.each do |monster_id, monster|
      if monsters_alive.include?(monster_id)
        distance_to_hero = Math.sqrt((monster.x - hero.x)**2 + (monster.y - hero.y)**2)
        distance_to_base = Math.sqrt((monster.x - base_x)**2 + (monster.y - base_y)**2)
        distance_to_base_hero_position = Math.sqrt((monster.x - base_hero_position[0])**2 + (monster.y - base_hero_position[1])**2)
        distance = distance_to_hero + 100 * distance_to_base + 10 * distance_to_base_hero_position
        monsters_distances << [monster, distance, distance_to_base, distance_to_hero] if distance_to_hero < 3000 || distance_to_base < 4500
      end
    end

    monsters_distances.sort! do |a, b|
      a[1] <=> b[1]
    end

    closest_monster = monsters_distances.first unless monsters_distances.empty?
    # gestion du monstre le plus proche
    if closest_monster.nil?
      hero.action = "MOVE #{base_hero_position[0]} #{base_hero_position[1]}"
      hero.target = "base position"
    elsif closest_monster[2] < 4000 && closest_monster[3] < 1200 && closest_monster[0].shield_life == 0
      hero.action = "SPELL WIND #{map_center[0]} #{map_center[1]}"
      hero.target = closest_monster.first.id
    else
      hero.action = "MOVE #{closest_monster.first.x} #{closest_monster.first.y}"
      hero.target = closest_monster.first.id
    end

    # rectification si tout le monde sur la meme target
    MY_HEROES.each do |other_hero_id, other_hero|
      if other_hero_id != hero_id && other_hero.target == hero.target && !closest_monster.nil? && !MONSTERS[hero.target].nil?
        monster = MONSTERS[hero.target]
        hero_distance = Math.sqrt((hero.x - monster.x)**2 + (hero.y - monster.y)**2)
        other_hero_distance = Math.sqrt((other_hero.x - monster.x)**2 + (other_hero.y - monster.y)**2)
        if hero_distance > other_hero_distance
          if monsters_distances[1].nil?
            hero.action = "MOVE #{base_hero_position[0]} #{base_hero_position[1]}"
            hero.target = "base position"
          else
            hero.target = monsters_distances[1][0].id
            hero.action = "MOVE #{monsters_distances[1][0].x} #{monsters_distances[1][0].y}"
          end
        end
      end
    end

    # protection contre le controle
    MY_HEROES.each do |other_hero_id, other_hero|
      if other_hero_id != hero_id
        if other_hero.is_controlled == 1
          distance = Math.sqrt((other_hero.x - hero.x)**2 + (other_hero.y - hero.y)**2)
          if distance < 2200
            hero.target = other_hero.id
            hero.action = "SPELL SHIELD #{hero.target}"
          end
        end
      end
    end


    puts "#{hero.action} hero #{hero.id}"
  end
end
