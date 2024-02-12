STDOUT.sync = true # DO NOT REMOVE
# Auto-generated code below aims at helping you parse
# the standard input according to the problem statement.

number_of_cells = gets.to_i # amount of hexagonal cells in this map
cells = []
number_of_cells.times do
    # type: 0 for empty, 1 for eggs, 2 for crystal
    # initial_resources: the initial amount of eggs/crystals on this cell
    # neigh_0: the index of the neighbouring cell for each direction
    type, initial_resources, neigh_0, neigh_1, neigh_2, neigh_3, neigh_4, neigh_5 = gets.split(" ").collect { |x| x.to_i }
    cells << [type, initial_resources, neigh_0, neigh_1, neigh_2, neigh_3, neigh_4, neigh_5]
end
STDERR.puts "cells #{cells}"
number_of_bases = gets.to_i
inputs = gets.split(" ")
bases_index = inputs
STDERR.puts "bases #{number_of_bases}"
STDERR.puts "inputs #{inputs}"
for i in 0..(number_of_bases-1)
    my_base_index = inputs[i].to_i
end
STDERR.puts "bas index #{my_base_index}"

inputs = gets.split(" ")
for i in 0..(number_of_bases-1)
    opp_base_index = inputs[i].to_i
end

# game loop
max_resources_cell = {id: 0}
loop do
  game_cells = []
  i = 0
  number_of_cells.times do
    # resources: the current amount of eggs/crystals on this cell
    # my_ants: the amount of your ants on this cell
    # opp_ants: the amount of opponent ants on this cell
    resources, my_ants, opp_ants = gets.split(" ").collect { |x| x.to_i }
    game_cells << {id: i, resources: resources, my_ants: my_ants, opp_ants: opp_ants}
    i += 1
  end

  # Write an action using puts
  # To debug: STDERR.puts "Debug messages..."
  STDERR.puts "cells #{game_cells}"
  STDERR.puts "cells #{game_cells.first[:resources]}"

  message = ["BEACON #{bases_index.first} 1;"]
  max_resources_cell = game_cells[max_resources_cell[:id]]
  STDERR.puts max_resources_cell

    if max_resources_cell[:resources] == 0
      game_cells.each do |cell|
        max_resources_cell = cell if cell[:resources] > max_resources_cell[:resources]
      end
    end
    message << " LINE #{max_resources_cell[:id]} #{bases_index.first} 1;"

    # WAIT | LINE <sourceIdx> <targetIdx> <strength> | BEACON <cellIdx> <strength> | MESSAGE <text>
    puts message.join
end
