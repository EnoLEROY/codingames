def find_path(grid, start_pos, end_pos)
  rows = grid.size
  cols = grid[0].size
  visited = Array.new(rows) { Array.new(cols, false) }
  parent = {}

  queue = [start_pos]
  visited[start_pos[0]][start_pos[1]] = true

  directions = [[1,0], [-1,0], [0,1], [0,-1]]

  while !queue.empty?
    curr = queue.shift
    return build_path(parent, start_pos, end_pos) if curr == end_pos

    directions.each do |dx, dy|
      new_x = curr[0] + dx
      new_y = curr[1] + dy

      if new_x.between?(0, rows - 1) &&
         new_y.between?(0, cols - 1) &&
         grid[new_x][new_y] == 0 &&
         !visited[new_x][new_y]

        visited[new_x][new_y] = true
        parent[[new_x, new_y]] = curr
        queue << [new_x, new_y]
      end
    end
  end

  return nil  # Aucun chemin trouvé
end

def build_path(parent, start_pos, end_pos)
  path = []
  current = end_pos

  while current != start_pos
    path << current
    current = parent[current]
  end

  path << start_pos
  path.reverse
end

# Exemple d'utilisation
grid = [
  [0, 0, 0, 1],
  [1, 1, 0, 1],
  [0, 0, 0, 0],
  [0, 1, 1, 0]
]
grid2 = [
  [0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0],
  [1, 1, 1, 1, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 1, 1, 1],
  [0, 0, 0, 0, 0, 0, 0],
]

map = grid2
start = [0, 0]
end_pos = [map.length-1, map[0].length-1]

path = find_path(map, start, end_pos)

if path
  puts "Chemin trouvé :"
  puts path.inspect
  path.each do |coord|
    map[coord[0]][coord[1]] = "\033[32m#{map[coord[0]][coord[1]]}\033[0m"
  end
  path_found = map.map do |row|
    row = row.map do |tile|
      tile
    end
    row.join
  end
  puts path_found
else
  puts "Aucun chemin trouvé."
end

puts "\033[32m"+"text"+"\033[0m"


