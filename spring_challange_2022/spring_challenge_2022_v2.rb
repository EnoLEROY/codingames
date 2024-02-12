STDOUT.sync = true # DO NOT REMOVE
# Auto-generated code below aims at helping you parse
# the standard input according to the problem statement.

# fonctions --------------------------------------------------
def distance(a, b)
  a = {x: a.x, y: a.y} if a.class == Monster || a.class == Hero
  b = {x: b.x, y: b.y} if b.class == Monster || b.class == Hero
  Math.sqrt((a[:x] - b[:x])**2 + (a[:y] - b[:y])**2)
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
  attr_accessor :role, :action, :target, :nearest_hero, :nearest_monster, :nearest_foe_hero
  def initialize(attrs)
    super
    @role = nil
    @action = ""
    @target = ""
    @nearest_hero = nil
    @nearest_monster = nil
    @nearest_foe_hero = nil
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

base_x == 0 ? foe_base = [17630, 9000] : foe_base = [0, 0]

FOE_HEROES = {}
MY_HEROES = {}
MONSTERS = {}
# game loop
loop do
  base = {health: 0, mana: 0}
  2.times do
    # health: Each player's base health
    # mana: Ignore in the first league; Spend ten mana to cast a spell
    health, mana = gets.split.map { |x| x.to_i }
    base[:health] = health
    base[:mana] = mana
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
        if MY_HEROES.keys.length == 1
          hero.role = "offence"
        else
          hero.role = "defence"
        end
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
  STDERR.puts "monster #{MONSTERS.keys}"

  # game states --------------------------------------------------------------
  MY_HEROES.each do |hero_id, hero|
    index = MY_HEROES.keys.index(hero.id)
    base_hero_position = base_positions_for_heroes[index]
    hero.nearest_foe_hero = nil
    hero.nearest_monster = nil

    monsters_distances = []
    MONSTERS.each do |monster_id, monster|
      distance_to_hero = Math.sqrt((monster.x - hero.x)**2 + (monster.y - hero.y)**2)
      distance_to_hero_base_position = Math.sqrt((monster.x - base_hero_position[0])**2 + (monster.y - base_hero_position[1])**2)
      distance_to_base = Math.sqrt((monster.x - base_x)**2 + (monster.y - base_y)**2)
      distance_to_base_hero_position = Math.sqrt((monster.x - base_hero_position[0])**2 + (monster.y - base_hero_position[1])**2)
      monsters_distances << [monster, distance_to_hero, distance_to_base, distance_to_hero_base_position]
    end

    monsters_distances.sort! do |a, b|
      a[3] <=> b[3]
    end
    # STDERR.puts "monster distacnes #{monsters_distances}"

    monster_closest_to_hero = monsters_distances.first unless monsters_distances.empty?

    monsters_distances.sort! do |a, b|
      a[2] <=> b[2]
    end

    monster_closest_to_base = monsters_distances.first unless monsters_distances.empty?

    if monster_closest_to_base.nil?
      hero.nearest_monster = nil
    elsif monster_closest_to_base[2] > 5000 && monster_closest_to_hero[3] > 3000
      hero.nearest_monster = nil
    elsif monster_closest_to_base[2] > 5000
      hero.nearest_monster = monster_closest_to_hero.first
    else
      hero.nearest_monster = monster_closest_to_base.first
    end

    foes_distances = []
    FOE_HEROES.each do |foe_id, foe|
      distance_to_hero = Math.sqrt((foe.x - hero.x)**2 + (foe.y - hero.y)**2)
      distance_to_base = Math.sqrt((foe.x - base_x)**2 + (foe.y - base_y)**2)
      foes_distances << [foe, distance_to_hero, distance_to_base] if distance_to_base < 6000
    end

    foes_distances.sort! do |a, b|
      a[1] <=> b[1]
    end

    hero.nearest_foe_hero = foes_distances.first.first  unless foes_distances.empty?

    other_heroes_distances = []
    MY_HEROES.each do |other_hero_id, other_hero|
      if other_hero_id != hero_id
        distance_to_hero = Math.sqrt((other_hero.x - hero.x)**2 + (other_hero.y - hero.y)**2)
        distance_to_base = Math.sqrt((other_hero.x - base_x)**2 + (other_hero.y - base_y)**2)
        other_heroes_distances << [other_hero, distance_to_hero, distance_to_base]
      end
    end

    other_heroes_distances.sort! do |a, b|
      a[1] <=> b[1]
    end

    hero.nearest_hero = other_heroes_distances.first.first
  end


  # descisions -----------------------------------------------------------------
  MY_HEROES.each do |hero_id, hero|
    index = MY_HEROES.keys.index(hero.id)
    base_hero_position = base_positions_for_heroes[index]
    STDERR.puts "hero #{hero.id}"
    # ordre de proiorité :
    # un hero est a moins de 2200 et is controlled == 1
    # un monstre est a moins de 3000 de la base Wind si pas proteger sinon on tape et a moins de 1200 vers le centre de la base enemmie
    # un hero a proximité et pas de dangées de monstre control spell a moins de 2200 vers la base enemie

    if hero.nearest_monster.nil?
      STDERR.puts "1er if: #{hero.nearest_monster}"
      hero.action = "MOVE"
      hero.target = "#{base_hero_position[0]} #{base_hero_position[1]}"

    elsif distance(hero, hero.nearest_monster) < 1000 && distance({x: base_x, y: base_y}, hero.nearest_monster) < 4000 && base[:mana] > 40 && hero.nearest_monster.shield_life == 0
      STDERR.puts "2eme if: #{hero.nearest_monster.id}, #{distance(hero, hero.nearest_monster).to_i}"
      hero.action = "SPELL WIND"
      hero.target = "#{foe_base[0]} #{foe_base[1]}"

    elsif hero.nearest_foe_hero.nil? || hero.nearest_hero.nil?
      STDERR.puts "3eme if: #{hero.nearest_monster.id}, #{hero.nearest_foe_hero}, #{hero.nearest_hero}"
      hero.action = "MOVE"
      hero.target = "#{hero.nearest_monster.x} #{hero.nearest_monster.y}"

    elsif distance(hero, hero.nearest_hero) < 2000 && hero.nearest_hero.shield_life == 0 && base[:mana] > 10 && distance(hero.nearest_hero, hero.nearest_foe_hero) < 2000
      STDERR.puts "5eme if: #{hero.nearest_hero.id}, #{distance(hero, hero.nearest_hero).to_i}"
      hero.action = "SPELL SHIELD"
      hero.target = hero.nearest_hero.id

    elsif distance({x: base_x, y: base_y}, hero.nearest_monster) < 4000 || hero.nearest_foe_hero.nil?
      STDERR.puts "5.5eme if: #{hero.nearest_monster.id}"
      hero.action = "MOVE"
      hero.target = "#{hero.nearest_monster.x} #{hero.nearest_monster.y}"

    elsif distance(hero, hero.nearest_foe_hero) < 2000 && distance({x: base_x, y: base_y}, hero.nearest_foe_hero) < 6000 && base[:mana] > 10
      STDERR.puts "6eme if: #{hero.nearest_foe_hero.id}, #{distance(hero, hero.nearest_foe_hero).to_i}"
      hero.action = "SPELL CONTROL"
      hero.target = "#{hero.nearest_foe_hero.id} #{foe_base[0]} #{foe_base[1]}"

    elsif distance({x: base_x, y: base_y}, hero.nearest_monster) < 4000
      STDERR.puts "7eme if: #{hero.nearest_monster.id}"
      hero.action = "MOVE"
      hero.target = "#{hero.nearest_monster.x} #{hero.nearest_monster.y}"

    else
      STDERR.puts "8eme if"
      hero.action = "MOVE"
      hero.target = "#{base_hero_position[0]} #{base_hero_position[1]}"
    end

    puts "#{hero.action} #{hero.target} hero #{hero.id}"
  end
end
