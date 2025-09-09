STDOUT.sync = true # DO NOT REMOVE
# Grow and multiply your organisms to end up larger than your opponent.

# width: columns in the game grid
# height: rows in the game grid
width, height = gets.split.map { |x| x.to_i }

class Cell
  attr_accessor :x, :y, :type, :owner, :organ_id, :organ_dir, :organ_parent_id, :organ_root_id
  
  def initialize(attrs)
    @x = attrs[:x]
    @y = attrs[:y]
    @type = attrs[:type]
    @owner = attrs[:owner]
    @organ_id = attrs[:organ_id]
    @organ_dir = attrs[:organ_dir]
    @organ_parent_id = attrs[:organ_parent_id]
    @organ_root_id = attrs[:organ_root_id]
  end

  def possible_move(cells)
    n = {x: @x, y: (@y - 1), prio: nil}
    s = {x: @x, y: (@y + 1), prio: nil}
    e = {x: (@x + 1), y: @y, prio: nil}
    w = {x: (@x - 1), y: @y, prio: nil}
    quad = [n, s, e, w]

    impossible.each do |temp|
      quad.delete(temp)
    end

    priority.each do |temp|
      quad.each do |q|
        if temp == q 
          return temp
        end
      end
    end
    return quad
  end
end

class Organism 
  attr_accessor :root, :organs

  def initialize(attrs)
    @root = attrs[:root]
    @organs = [attrs[:root]]
  end
end


cells = []
my_cells = []
opp_cells = []
walls = []
proteins = []
organisms = []

# game loop
loop do
  entity_count = gets.to_i
  entity_count.times do
    # y: grid coordinate
    # type: WALL, ROOT, BASIC, TENTACLE, HARVESTER, SPORER, A, B, C, D
    # owner: 1 if your organ, 0 if enemy organ, -1 if neither
    # organ_id: id of this entity if it's an organ, 0 otherwise
    # organ_dir: N,E,S,W or X if not an organ
    x, y, type, owner, organ_id, organ_dir, organ_parent_id, organ_root_id = gets.split
    x = x.to_i
    y = y.to_i
    owner = owner.to_i
    organ_id = organ_id.to_i
    organ_parent_id = organ_parent_id.to_i
    organ_root_id = organ_root_id.to_i
    if type != "WALL"
      # STDERR.puts "x: #{x}, y: #{y}, owner: #{owner}, type: #{type}, organ_id: #{organ_id}, organ_dir: #{organ_dir}, organ_parent_id: #{organ_parent_id}, organ_root_id: #{organ_root_id}"
    end

    cell = cells.select do |cell|
      cell.organ_id == organ_id
    end
    
    cell = cell.first

    if cell == nil 
      new_cell = Cell.new({
        x: x, 
        y: y,
        type: type,
        owner: owner,
        organ_id: organ_id,
        organ_dir: organ_dir,
        organ_parent_id: organ_parent_id,
        organ_root_id: organ_root_id
      })
      cells << new_cell
      walls << new_cell if new_cell.type == "WALL"
      proteins << new_cell if new_cell.type == "A"
      my_cells << new_cell if new_cell.owner == 1
      opp_cells << new_cell if new_cell.owner == 0
      
      if new_cell.type == "ROOT"
        Organism.new({
          root: new_cell
        })
      elsif new_cell.organ_id == 1
        organism = organisms.select do |x|
          x.root.organ_id == new_cell.organ_id
        end
        organism.first.organs << new_cell
      end
    else 
      cell.x = x 
      cell.y = y 
      cell.organ_dir = organ_dir 
    end
  end

  # STDERR.puts cells 



  # my_d: your protein stock
  my_a, my_b, my_c, my_d = gets.split.map { |x| x.to_i }
  STDERR.puts "my_a: #{my_a}, my_b: #{my_b}, my_c: #{my_c}, my_d: #{my_d}"
  
  # opp_d: opponent's protein stock
  opp_a, opp_b, opp_c, opp_d = gets.split.map { |x| x.to_i }
  STDERR.puts "opp_a: #{opp_a}, opp_b: #{opp_b}, opp_c: #{opp_c}, opp_d: #{opp_d}"
  required_actions_count = gets.to_i # your number of organisms, output an action for each one in any order
  # STDERR.puts "require action #{required_actions_count}"
  # required_actions_count.times do

  #   # Write an action using puts
  #   # To debug: STDERR.puts "Debug messages..."

  #   puts "WAIT"
  # end

  # impossible = []
  # walls.each do |cell|
  #   impossible << {x: cell.x, y: cell.y, prio: nil}
  # end
  
  # my_cells.each do |cell|
  #   impossible << {x: cell.x, y: cell.y, prio: nil}
  # end
  
  # priority = []
  # proteins.each do |cell|
  #   priority << {x: cell.x, y: cell.y, prio: true}
  # end


  organisms.each do |organism|
    possiblitities = []
    organism.organs.each do |cell|
      possiblitities << cell.possible_move(cells)
    end
    possiblitities.flatten!

    priority = possiblitities.select do |pos|
      pos[:prio] = true
    end

    if priority.length == 0
      move = possiblitities.first
    else
      move = priority.first
    end

    puts "GROW #{cell.organ_id} #{move[:x]} #{move[:y]} BASIC"
  end

end
