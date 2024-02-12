STDOUT.sync = true # DO NOT REMOVE
# Auto-generated code below aims at helping you parse
# the standard input according to the problem statement.
# class Cell
#   attr_accessor :id, :type, :neigh_0, :neigh_1, :neigh_2, :neigh_3, :neigh_4, :neigh_5, :resources, :my_ants, :opp_ants

#   def initialize(attrs)
#     @id = attrs[:id]
#     @type = attrs[:type]
#     @neigh_0 = attrs[:neigh_0]
#     @neigh_1 = attrs[:neigh_1]
#     @neigh_2 = attrs[:neigh_2]
#     @neigh_3 = attrs[:neigh_3]
#     @neigh_4 = attrs[:neigh_4]
#     @neigh_5 = attrs[:neigh_5]
#     @resources = attrs[:resources]
#     @my_ants = attrs[:my_ants]
#     @opp_ants = attrs[:opp_ants]
#   end


# end

# fonctions ---------------------------------------------------------------
def unique(specific_cells, cells)
  ids = []
  specific_cells.each do |cell|
    ids << cell[:id]
    ids.uniq
  end
  array_of_cells = []
  cells.each do |cell|
    array_of_cells << cell if ids.include?(cell[:id])
  end
  return array_of_cells
end

def is_there_a_path_to_base?(cell, my_bases, cells, cells_with_my_ants)
  cells_to_test = [cell]
  ids = []
  3.times do
    # STDERR.puts "cells to test #{cells_to_test.length}"
    cells_to_test.each do |cell|
      ids << cell[:id]
      neighbour_cells = neighbour_cells(cell, cells)
      # STDERR.puts neighbour_cells.length
      neighbour_cells.each do |neighbour_cell|
        cells_to_test << neighbour_cell if (neighbour_cell[:my_ants] !=0 && !ids.include?(neighbour_cell[:id]))
      end
      return true if my_bases.include?(cell[:id])
    end

  end
  return false
end

def max_resources_cell_id?(cells, target_cell)
  cells.each do |cell|
    target_cell = cell if cell[:resources] > target_cell[:resources]
  end
  return target_cell[:id]
end

def neighbour_cells(target_cell, cells_selection)
  neighbour_cells_ids = [
    target_cell[:neigh_0],
    target_cell[:neigh_1],
    target_cell[:neigh_2],
    target_cell[:neigh_3],
    target_cell[:neigh_4],
    target_cell[:neigh_5],
  ]
  neighbour_cells = []
  cells_selection.each do |cell|
    neighbour_cells << cell if neighbour_cells_ids.include?(cell[:id])
  end
  return neighbour_cells
end

def closest_resource_cell(cell, specific_cells, all_cells, number = 30)
  closest_cell = 0
  cells = [cell]
  base_cell_id = cell[:id]

  number.times do

    adjacent_cells = []
    cells.each do |cell|
      adjacent_cells << neighbour_cells(cell, specific_cells)
    end
    # STDERR.puts "closest egg cell #{i} fois"

    closest_cells = []
    adjacent_cells.flatten.each do |cell|
      closest_cells << cell if cell[:resources] !=0 && cell[:id] != base_cell_id
      # STDERR.puts "clossest cell #{closest_cell}"
    end
    return closest_cells unless closest_cells.empty?

    if closest_cell == 0
      # STDERR.puts 'nouvelles cells'
      new_cells = []
      cells.each do |cell|
        new_cells << neighbour_cells(cell, all_cells)
      end
      cells = new_cells.flatten
    end

    ids = []
    cells.each do |cell|
      ids << cell[:id]
    end
    ids.uniq!
    ids.delete(base_cell_id)
    cells = []
    all_cells.each do |cell|
      cells << cell if ids.include?(cell[:id])
    end
    # STDERR.puts "cells radius #{cells}"

  end
  return nil
end


number_of_cells = gets.to_i # amount of hexagonal cells in this map
cells = []
i = 0
number_of_cells.times do
    # type: 0 for empty, 1 for eggs, 2 for crystal
    # initial_resources: the initial amount of eggs/crystals on this cell
    # neigh_0: the index of the neighbouring cell for each direction
    type, initial_resources, neigh_0, neigh_1, neigh_2, neigh_3, neigh_4, neigh_5 = gets.split(" ").collect { |x| x.to_i }
    cells << {
      id: i,
      type: type,
      initial_resources: initial_resources,
      neigh_0: neigh_0,
      neigh_1: neigh_1,
      neigh_2: neigh_2,
      neigh_3: neigh_3,
      neigh_4: neigh_4,
      neigh_5: neigh_5
    }
    i += 1
end
# STDERR.puts "cells #{cells}"
number_of_bases = gets.to_i
inputs = gets.split(" ")

my_bases = []
for i in 0..(number_of_bases-1)
    my_base_index = inputs[i].to_i
    my_bases << my_base_index
end
STDERR.puts "base index #{my_bases}"

inputs = gets.split(" ")
opp_bases = []
for i in 0..(number_of_bases-1)
    opp_base_index = inputs[i].to_i
    opp_bases << opp_base_index
end

initial_cristal_cells = []
initial_empty_cells = []
initial_egg_cells = []
my_bases_cells = []
cells.each do |cell|
  initial_empty_cells << cell if cell[:type] == 0
  initial_egg_cells << cell if cell[:type] == 1
  initial_cristal_cells << cell if cell[:type] == 2
  my_bases_cells << cell if my_bases.include?(cell[:id])
end


initial_total_eggs = 0
initial_egg_cells.each do |cell|
  initial_total_eggs += cell[:initial_resources]
end
STDERR.puts "total eggs #{initial_total_eggs}"


message_to_keep = []
# game loop -----------------------------------------------------------------
target_cell = {id: my_bases.first}
loop do
  # beacon sur chacune des bases
  message = []
  # my_bases.each do |base|
  #   message << ["BEACON #{base} 1;"]
  # end
  # etat du plateau ---------------------------------------------------------
  i = 0
  number_of_cells.times do
    # resources: the current amount of eggs/crystals on this cell
    # my_ants: the amount of your ants on this cell
    # opp_ants: the amount of opponent ants on this cell
    resources, my_ants, opp_ants = gets.split(" ").collect { |x| x.to_i }
    cells[i][:resources] = resources
    cells[i][:my_ants] = my_ants
    cells[i][:opp_ants] = opp_ants

    i += 1
  end


  # Write an action using puts ----------------------------------------------
  # To debug: STDERR.puts "Debug messages..."
  # STDERR.puts "cells in game #{cells}"

  # types de cells -----------------
  cristal_cells = []
  empty_cells = []
  egg_cells = []
  cells_with_my_ants = []
  all_cell_with_resources = []
  cells.each do |cell|
    empty_cells << cell if cell[:type] == 0
    egg_cells << cell if cell[:type] == 1
    cristal_cells << cell if cell[:type] == 2
    cells_with_my_ants << cell if cell[:my_ants] != 0
    all_cell_with_resources << cell if cell[:resources] != 0
  end
  STDERR.puts "cells with ants = #{cells_with_my_ants.length}"

  total_eggs = 0
  egg_cells.each do |cell|
    total_eggs += cell[:resources]
  end
  STDERR.puts "total eggs #{total_eggs}"
  total_ants = 0
  cells.each do |cell|
    total_ants += cell[:my_ants]
  end
  STDERR.puts "total ants #{total_ants}"



  ids_of_targeted_cells = []
  # aller chercher les oeufs ------------
  if total_eggs != 0
    target_egg_cells = closest_resource_cell(cells[my_bases.first], egg_cells, cells)
    STDERR.puts "target egg cell #{target_egg_cells}"
    unless target_egg_cells.nil?
      STDERR.puts "target egg cell #{target_egg_cells.length}"
      target_egg_cells.each do |target_egg_cell|
        message << "LINE #{target_egg_cell[:id]} #{my_bases.first} 1; MESSAGE egg 248;" unless target_egg_cell.nil?
        adjacent_resources_cells = closest_resource_cell(target_egg_cell, all_cell_with_resources, cells, 1)
        unless adjacent_resources_cells.nil?
          adjacent_resources_cells.each do |cell|
            message << "LINE #{cell[:id]} #{my_bases.first} 1; MESSAGE egg 252;"
            ids_of_targeted_cells << cell[:id]
          end
        end
      end
    end
  end

  begin_looking_for_cristals = false
  egg_cells.each do |egg_cell|
    if egg_cell[:resources] == egg_cell[:resources] / 2
      begin_looking_for_cristals = true
    end
  end
  STDERR.puts begin_looking_for_cristals
  if begin_looking_for_cristals
    target_cristal_cells = []
    cristal_cells.each do |cell|
      target_cristal_cells << cell if cell[:resources] != 0
    end

    closest_to_base = closest_resource_cell(my_bases_cells.first, cristal_cells, cells)
    message << "LINE #{closest_to_base.first[:id]} #{my_bases_cells.first[:id]} 1; MESSAGE clossest_to_base;"
    ids_of_targeted_cells << closest_to_base.first[:id]

    target_cristal_cells.each do |cell|
      closest_with_ants = closest_resource_cell(cell, cells_with_my_ants, cells)
      # STDERR.puts "closest with ants #{closest_with_ants}"
      closest_with_ants.nil? ? second_beacon = my_bases.first : second_beacon = closest_with_ants.first[:id]
      closest_resource_cell = closest_resource_cell(cell, cristal_cells, cells, 2)
      second_beacon = closest_resource_cell.first[:id] unless closest_resource_cell.nil?
      # unless closest_resource_cell.nil?
      #   if second_beacon == closest_resource_cell.first[:id]
      #     ids_of_targeted_cells << cell[:id]
      #   end
      # end
      message << "LINE #{cell[:id]} #{second_beacon} 1; MESSAGE closest_to_resource;"
      # STDERR.puts is_there_a_path_to_base?(cell, my_bases, cells, cells_with_my_ants)
      unless is_there_a_path_to_base?(cell, my_bases, cells, cells_with_my_ants)
        message_to_keep << "LINE #{cell[:id]} #{my_bases.first} 1; MESSAGE to_base;" unless ids_of_targeted_cells.include?(cell[:id])
        # STDERR.puts "je suis dans la ligne 267 #{message.last}"
      end
    end
  end



  temp = Array.new(message_to_keep)
  message_to_keep.each do |m|
    dm = m.split(' ')
    # STDERR.puts "dm #{dm}"
    index = dm[1].to_i
    # STDERR.puts "dm[1] #{index}"
    # STDERR.puts cells.length
    message_cell = []
    cells.each do |cell|
      message_cell << cell if cell[:id] == index
    end
    # STDERR.puts message_cell
    if message_cell.first[:resources] == 0
      temp.delete(m)
    end
    STDERR.puts "path to base ? #{is_there_a_path_to_base?(message_cell.first, my_bases, cells, cells_with_my_ants)}"
    if is_there_a_path_to_base?(message_cell.first, my_bases, cells, cells_with_my_ants)
      temp.delete(m)
    end
  end
  message_to_keep = temp

  message_to_keep.each { |m| message << m }

  message.each do |message|

  end
  # results ---------------------------------------------------------------
  # WAIT | LINE <sourceIdx> <targetIdx> <strength> | BEACON <cellIdx> <strength> | MESSAGE <text>
  puts message.uniq.join
end
