# Auto-generated code below aims at helping you parse
# the standard input according to the problem statement.

l, c = gets.split(" ").collect { |x| x.to_i }
rows = []
l.times do
  row = gets.chomp
  rows << row
end
STDERR.puts l
STDERR.puts c
STDERR.puts rows
STDERR.puts "#{rows}"

class Blunder
  attr_accessor :x, :y, :inversor, :casseur, :direction, :stop
  PRIORITIES = [:south, :east, :north, :west]

  def initialize(attrs)
    @x = attrs[:x]
    @y = attrs[:y]
    @inversor = attrs[:inversor] || false
    @casseur = attrs[:casseur] || false
    @direction = attrs[:direction] || :south
    @stop = false
  end

  def coords_update
    case @direction
    when :south
      @y += 1
    when :north
      @y -= 1
    when :east
      @x += 1
    when :west
      @x -= 1
    end
  end

  def can_move?(adjacent_tile)
    case adjacent_tile
    when "#"
      return false
    when "X"
      return @casseur
    else
      return true
    end
  end

  def found_the_target?(adjacent_tile)
    @stop = true if adjacent_tile == "$"
  end

  def special_event(bottles, teleport, inversors)
    bottles.each do |bottle|
      @casseur = !@casseur if bottle == [@x, @y]
    end

    if [@x, @y] == teleport[0]
      @x = teleport[1][0]
      @y = teleport[1][1]
    elsif [@x, @y] == teleport[1]
      @x = teleport[0][0]
      @y = teleport[0][1]
    end

    inversors.each do |invers|
      @inversor = !@inversor if invers == [@x, @y]
    end
  end

end

# Write an answer using puts
# To debug: STDERR.puts "Debug messages..."

def blunder_next_move(around_blunder, blunder)
  if blunder.can_move?(around_blunder[blunder.direction])
    return blunder.direction.to_s
  else
    if blunder.inversor == false
      Blunder::PRIORITIES.each do |direction|
        if blunder.can_move?(around_blunder[direction])
          blunder.direction = direction
          return direction.to_s
        end
      end
    else
      Blunder::PRIORITIES.reverse.each do |direction|
        if blunder.can_move?(around_blunder[direction])
          blunder.direction = direction
          return direction.to_s
        end
      end
    end
  end
end

# initialisation

target = [rows[rows.index { |x| x.include?("$")}].index("$"), rows.index { |x| x.include?("$")}]
bottles = []
teleport = []
inversors = []
direct_instructions = {}
rows.each_with_index do |row, y|
  row.split('').each_with_index do |tile, x|
    bottles << [x, y] if tile == "B"
    teleport << [x, y] if tile == "T"
    inversors << [x, y] if tile == "I"
    direct_instructions[[x, y]] = :south if tile == "S"
    direct_instructions[[x, y]] = :north if tile == "N"
    direct_instructions[[x, y]] = :east if tile == "E"
    direct_instructions[[x, y]] = :west if tile == "W"
  end
end

attrs = {
  y: rows.index { |x| x.include?("@")},
  x: rows[rows.index { |x| x.include?("@")}].index("@")
}

blunder = Blunder.new(attrs)
STDERR.puts "target: #{target} - bottles #{bottles} - teleport #{teleport} - blunder: #{blunder}"

blunder_path = []
i = 0
loop_breaker = 300
loop do
  blunder_coords = [blunder.x, blunder.y]

  around_blunder = {
    north: rows[blunder.y - 1][blunder.x],
    south: rows[blunder.y + 1][blunder.x],
    east: rows[blunder.y][blunder.x + 1],
    west: rows[blunder.y][blunder.x - 1]
  }


  #blunder next move
  if !direct_instructions[[blunder.x, blunder.y]].nil?
    blunder.direction = direct_instructions[[blunder.x, blunder.y]]
    output = direct_instructions[[blunder.x, blunder.y]].to_s
  else
    output = blunder_next_move(around_blunder, blunder)
  end

  blunder_path << output.upcase
  # puts output.class
  # puts "output: #{output} - blunder direction #{blunder.direction}"

  # update des coords de blunder en fonction de la direction
  blunder.coords_update
  blunder.found_the_target?(around_blunder[blunder.direction])
  blunder.special_event(bottles, teleport, inversors)

  # mise a jour de row
  rows[blunder_coords[1]][blunder_coords[0]] = " "
  # remise des bouteilles
  bottles.each do |bottle|
    rows[bottle[1]][bottle[0]] = "B"
  end
  teleport.each do |teleport|
    rows[teleport[1]][teleport[0]] = "T"
  end
  inversors.each do |inversor|
    rows[inversor[1]][inversor[0]] = "I"
  end
  rows[blunder.y][blunder.x] = "@"

  i += 1
  break if i >= loop_breaker || blunder.stop == true
end

if blunder.stop == true
  blunder_path.each { |path| puts path }
elsif i >= loop_breaker
  puts "LOOP"
else
  puts "something's wrong"
end
