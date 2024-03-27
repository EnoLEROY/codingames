# Auto-generated code below aims at helping you parse
# the standard input according to the problem statement.


w = gets.to_i
h = gets.to_i
grid = []
h.times do
  line = gets.chomp
  STDERR.puts line
  grid << line
end

# Write an answer using puts
# To debug: STDERR.puts "Debug messages..."
grid_archives = {}
i = 0

10.times do 
  grid_archives[i] = Array.new(grid)
  STDERR.puts "____________#{i}_______________" 
  STDERR.puts grid_archives[i]
  new_grid = Array.new(grid)
  STDERR.puts'ids'
  STDERR.puts new_grid.object_id
  STDERR.puts grid.object_id

  grid.each_with_index do |line, line_id|
    line.split('').each_with_index do |char, char_id|
      if "AZERTYUIOPQSDFGHJKLMWXCNVB".include?(char)
        [[line_id, char_id-1], [line_id, char_id+1], [line_id-1, char_id], [line_id+1, char_id]].each do |temp|
          if grid[temp[0]] != nil && grid[temp[0]][temp[1]] != nil
            if grid[temp[0]][temp[1]] == '.' && grid_archives[i][temp[0]][temp[1]] == '.'
              STDERR.puts char
              STDERR.puts grid[temp[0]][temp[1]]
              STDERR.puts new_grid[temp[0]][temp[1]]
              STDERR.puts '_-_-_-____--_--__'
              new_grid[temp[0]][temp[1]] = String.new(char)
              STDERR.puts grid[temp[0]][temp[1]]
              STDERR.puts new_grid[temp[0]][temp[1]]
            # elsif grid[temp[0]][temp[1]] != '.' && grid_archives[i][temp[0]][temp[1]] == '.'
            #   new_grid[temp[0]][temp[1]] = '+'
            end
          end
        end
      end
    end
  end
  STDERR.puts '---------____________--------'
  STDERR.puts grid
  STDERR.puts new_grid
  grid = Array.new(new_grid)
  i += 1
end



puts "answer"
