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
