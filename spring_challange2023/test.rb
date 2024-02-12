require_relative 'cell'

cells = []

infos = [
  {:index=>0, :type=>2, :initial_resources=>56, :neighbours=>[-1, 1, -1, -1, 2, -1]},
  {:index=>1, :type=>0, :initial_resources=>0, :neighbours=>[5, 7, 9, -1, 0, -1]},
  {:index=>2, :type=>0, :initial_resources=>0, :neighbours=>[-1, 0, -1, 6, 8, 10]},
  {:index=>3, :type=>0, :initial_resources=>0, :neighbours=>[15, -1, 5, -1, 14, 20]},
  {:index=>4, :type=>0, :initial_resources=>0, :neighbours=>[-1, 13, 19, 16, -1, 6]},
  {:index=>5, :type=>0, :initial_resources=>0, :neighbours=>[-1, 17, 7, 1, -1, 3]},
  {:index=>6, :type=>0, :initial_resources=>0, :neighbours=>[2, -1, 4, -1, 18, 8]},
  {:index=>7, :type=>0, :initial_resources=>0, :neighbours=>[17, -1, -1, 9, 1, 5]},
  {:index=>8, :type=>0, :initial_resources=>0, :neighbours=>[10, 2, 6, 18, -1, -1]},
  {:index=>9, :type=>0, :initial_resources=>0, :neighbours=>[7, -1, -1, 11, -1, 1]},
  {:index=>10, :type=>0, :initial_resources=>0, :neighbours=>[12, -1, 2, 8, -1, -1]},
  {:index=>11, :type=>0, :initial_resources=>0, :neighbours=>[9, -1, -1, -1, 13, -1]},
  {:index=>12, :type=>0, :initial_resources=>0, :neighbours=>[-1, 14, -1, 10, -1, -1]},
  {:index=>13, :type=>1, :initial_resources=>12, :neighbours=>[-1, 11, -1, 19, 4, -1]},
  {:index=>14, :type=>1, :initial_resources=>12, :neighbours=>[20, 3, -1, -1, 12, -1]},
  {:index=>15, :type=>2, :initial_resources=>6, :neighbours=>[21, 23, -1, 3, 20, 30]},
  {:index=>16, :type=>2, :initial_resources=>6, :neighbours=>[4, 19, 29, 22, 24, -1]},
  {:index=>17, :type=>2, :initial_resources=>42, :neighbours=>[25, -1, -1, 7, 5, -1]},
  {:index=>18, :type=>2, :initial_resources=>42, :neighbours=>[8, 6, -1, 26, -1, -1]},
  {:index=>19, :type=>0, :initial_resources=>0, :neighbours=>[13, -1, 27, 29, 16, 4]},
  {:index=>20, :type=>0, :initial_resources=>0, :neighbours=>[30, 15, 3, 14, -1, 28]},
  {:index=>21, :type=>0, :initial_resources=>0, :neighbours=>[-1, -1, 23, 15, 30, -1]},
  {:index=>22, :type=>0, :initial_resources=>0, :neighbours=>[16, 29, -1, -1, -1, 24]},
  {:index=>23, :type=>0, :initial_resources=>0, :neighbours=>[-1, -1, 25, -1, 15, 21]},
  {:index=>24, :type=>0, :initial_resources=>0, :neighbours=>[-1, 16, 22, -1, -1, 26]},
  {:index=>25, :type=>0, :initial_resources=>0, :neighbours=>[-1, -1, -1, 17, -1, 23]},
  {:index=>26, :type=>0, :initial_resources=>0, :neighbours=>[18, -1, 24, -1, -1, -1]},
  {:index=>27, :type=>0, :initial_resources=>0, :neighbours=>[-1, -1, -1, -1, 29, 19]},
  {:index=>28, :type=>0, :initial_resources=>0, :neighbours=>[-1, 30, 20, -1, -1, -1]},
  {:index=>29, :type=>0, :initial_resources=>0, :neighbours=>[19, 27, -1, -1, 22, 16]},
  {:index=>30, :type=>0, :initial_resources=>0, :neighbours=>[-1, 21, 15, 20, 28, -1]}
]

infos.each do |info|
  cells << Cell.new(info)
end

cells.each { |cell| cell.update_neighbours(cells) }
puts "------"
cells[0].neighbours.each { |x| puts x.index}
puts "------"

puts cells[0].index.class

puts "je cherche le plus court de 0 a 1"
p Cell.find_shortest_path(cells, cells[0], cells[1])


puts "je cherche le plus court de 9 a 17: le chemin devrait etre 9,7,17"
p Cell.find_shortest_path(cells, cells[9], cells[17])
