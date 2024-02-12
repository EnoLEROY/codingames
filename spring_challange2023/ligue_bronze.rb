STDOUT.sync = true # DO NOT REMOVE
# Auto-generated code below aims at helping you parse
# the standard input according to the problem statement.

number_of_cells = gets.to_i # amount of hexagonal cells in this map
cells = []
i = 0
number_of_cells.times do
  # type: 0 for empty, 1 for eggs, 2 for crystal
  # initial_resources: the initial amount of eggs/crystals on this cell
  # neigh_0: the index of the neighbouring cell for each direction
  type, initial_resources, neigh_0, neigh_1, neigh_2, neigh_3, neigh_4, neigh_5 = gets.split(" ").collect { |x| x.to_i }
  cells << Cell.new({
    index: i,
    type: type,
    initial_resources: initial_resources,
    neighbours: [neigh_0, neigh_1, neigh_2, neigh_3, neigh_4, neigh_5]
    })
  i+=1
end
number_of_bases = gets.to_i
inputs = gets.split(" ")
for i in 0..(number_of_bases-1)
  my_base_index = inputs[i].to_i
  cells[my_base_index].type = "base"
end
inputs = gets.split(" ")
for i in 0..(number_of_bases-1)
  opp_base_index = inputs[i].to_i
  cells[my_base_index].type = "enemmy base"
end
cells.each { |cell| cell.update_neighbours(cells) }

# game loop
loop do
  for i in 0...number_of_cells
    # resources: the current amount of eggs/crystals on this cell
    # my_ants: the amount of your ants on this cell
    # opp_ants: the amount of opponent ants on this cell
    resources, my_ants, opp_ants = gets.split(" ").collect { |x| x.to_i }
    cells[i].resources = resources
    cells[i].resources = my_ants
    cells[i].resources = opp_ants
  end

  # Write an action using puts
  # To debug: STDERR.puts "Debug messages..."


  # WAIT | LINE <sourceIdx> <targetIdx> <strength> | BEACON <cellIdx> <strength> | MESSAGE <text>
  puts "WAIT"
end
