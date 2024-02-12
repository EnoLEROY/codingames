class Cell
  attr_accessor index:, type:, initial_resources:, neighbours:, resources:, my_ants:, opp_ants:


  def initialize(attrs)
    @index = attrs[:index]
    case attrs[:type]
    when 0
      @type = "empty"
    when 1
      @type = "eggs"
    when 2
      @type = "cristals"

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

  def find_shortest_path(cells, start_cell, end_cell)
    paths = all_paths(cells, start_cell, end_cell, [], [])
    paths.delete_if { |path| (path[0] != start_cell.index || path[-1] != end_cell.index) }
    shortest = paths.min
    return shortest
  end

  def all_paths(cells, start_cell, end_cell, path, paths)
    start_cell.neighbours.each do |cell|
      path << cell.index
      find_path(cells, cell, end_cell, path, paths)
      paths << path if path[-1] == end_cell.index
    end
    return paths
  end

  def update_neighbours(cells)
    @neighbours.map! do |index|
      cells[index]
    end
  end
end
