class Cell
  attr_accessor :index, :type, :initial_resources, :neighbours, :resources, :my_ants, :opp_ants

  def initialize(attrs)
    @index = attrs[:index]
    case attrs[:type]
    when 0
      @type = "empty"
    when 1
      @type = "eggs"
    when 2
      @type = "cristals"
    end

    @initial_resources = attrs[:initial_resources]
    @neighbours = attrs[:neighbours]
    # @neigh_0 = attrs[:neigh_0]
    # @neigh_1 = attrs[:neigh_1]
    # @neigh_2 = attrs[:neigh_2]
    # @neigh_3 = attrs[:neigh_3]
    # @neigh_4 = attrs[:neigh_4]
    # @neigh_5 = attrs[:neigh_5]
    @resources
    @my_ants
    @opp_ants
  end

  def self.find_shortest_path(cells, start_cell, end_cell)
    paths = start_cell.all_paths(cells, end_cell, [start_cell.index], [])
    p paths
    puts '________'
    paths.delete_if { |path| (path[0] != start_cell.index || path[-1] != end_cell.index) }
    shortest = paths.min
    return shortest
  end

  def all_paths(cells, end_cell, path, paths)
    p paths
    p path
    puts '$$$$$$$$'
    neighbours = self.neighbours
    neighbours.delete_if { |neigh| path.include?(neigh.index) }
    neighbours.delete_if { |neigh| paths.each { |path| path.include?(neigh.index) }}
    for i in 0...neighbours.length
      cell = neighbours[i]
      path << cell.index
      puts cell.index
      if cell.index == end_cell.index
        paths << path
        p path
        p paths
        puts "******"
        return paths
      else
        cell.all_paths(cells, end_cell, path, paths)
      end
    end
    return paths
  end


  def update_neighbours(cells)
    @neighbours.map! do |index|
      cells[index] if index != -1
    end
    @neighbours.delete_if { |n| n.nil?}
  end
end
