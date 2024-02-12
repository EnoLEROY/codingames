require_relative "blunder"

# 1st labyrinth :
problem1 = ["#####", "#@  #", "#   #", "#  $#", "#####"]

# 2nd labyrinth :
problem2 = ["########", "# @    #", "#     X#", "# XXX  #", "#   XX #", "#   XX #", "#     $#", "########"]

# 3rd labyrinth :
problem3 = ["########", "#     $#", "#      #", "#      #", "#  @   #", "#      #", "#      #", "########"]

# 4th labyrinth :
problem4 = ["########", "#      #", "# @    #", "# XX   #", "#  XX  #", "#   XX #", "#     $#", "########"]

# 5th labyrinth :
problem5 = ["##########", "#        #", "#  S   W #", "#        #", "#  $     #", "#        #", "\#@       #", "#        #", "#E     N #", "##########"]

# 6th labyrinth :
problem6 = ["##########", "# @      #", "# B      #", "#XXX     #", "# B      #", "#    BXX$#", "#XXXXXXXX#", "#        #", "#        #", "##########"]

# 7th labyrinth :
problem7 =["##########", "#    I   #", "#        #", "#       $#", "#       @#", "#        #", "#       I#", "#        #", "#        #", "##########"]

# 8th labyrinth :
problem8 = ["##########", "#    T   #", "#        #", "#        #", "#        #", "\#@       #", "#        #", "#        #", "#    T  $#", "##########"]

# 9th labyrinth :
problem9 = ["##########", "#        #", "#  @     #", "#  B     #", "#  S   W #", "# XXX    #", "#  B   N #", "# XXXXXXX#", "#       $#", "##########"]

# 10th labyrinth :
problem10 = ["###############", "#      IXXXXX #", "#  @          #", "#             #", "#             #", "#  I          #", "#  B          #", "#  B   S     W#", "#  B   T      #", "#             #", "#         T   #", "#         B   #", "#            $#", "#        XXXX #", "###############"]

# 11th labyrinth :
problem11 = ["###############", "#      IXXXXX #", "#  @          #", "#E S          #", "#             #", "#  I          #", "#  B          #", "#  B   S     W#", "#  B   T      #", "#             #", "#         T   #", "#         B   #", "#N          W$#", "#        XXXX #", "###############"]

# 12th labyrinth :
problem12 = ["###############", "#  \#@#I  T$#  #", "#  #    IB #  #", "#  #     W #  #", "#  #      ##  #", "#  #B XBN# #  #", "#  ##      #  #", "#  #       #  #", "#  #     W #  #", "#  #      ##  #", "#  #B XBN# #  #", "#  ##      #  #", "#  #       #  #", "#  #     W #  #", "#  #      ##  #", "#  #B XBN# #  #", "#  ##      #  #", "#  #       #  #", "#  #       #  #", "#  #      ##  #", "#  #  XBIT #  #", "#  #########  #", "#             #", "# ##### ##### #", "# #     #     #", "# #     #  ## #", "# #     #   # #", "# ##### ##### #", "#             #", "###############"]

problems = {
  1 => problem1,
  2 => problem2,
  3 => problem3,
  4 => problem4,
  5 => problem5,
  6 => problem6,
  7 => problem7,
  8 => problem8,
  9 => problem9,
  10 => problem10,
  11 => problem11,
  12 => problem12
}
# blunder rules :
# Les 9 règles du nouveau système Blunder :

# Blunder part de l’endroit indiqué par le caractère @ sur la carte et se dirige vers le SUD.
# Blunder termine son parcours et meurt lorsqu’il rejoint la cabine à suicide notée $.
# Les obstacles que Blunder peut rencontrer sont représentés par # ou X.
# Lorsque Blunder rencontre un obstacle, il change de direction en utilisant les priorités suivantes : SUD, EST, NORD et OUEST. Il essaie donc d’abord d’aller au SUD, s’il ne peut pas il va à l’EST, s’il ne peut toujours pas il va au NORD, et finalement s'il ne peut toujours pas il va à l’OUEST.
# Sur son chemin, Blunder peut rencontrer des modificateurs de trajectoire qui vont lui faire changer instantanément de direction. Le modificateur S l'orientera désormais vers le SUD, E vers l’EST, N vers le NORD et W vers l’OUEST.
# Les inverseurs de circuits (I sur la carte) produisent un champ magnétique qui vont inverser les priorités de direction que Blunder devrait choisir à la rencontre d’un obstacle. Les priorités deviendront OUEST, NORD, EST, SUD. Si Blunder retourne sur un inverseur I, les priorités repassent à leur état d’origine (SUD, EST, NORD, OUEST).
# Blunder peut aussi trouver quelques bières sur son parcours (B sur la carte) qui vont lui donner de la force et le faire passer en mode Casseur. Le mode Casseur permet à Blunder de détruire et de traverser automatiquement les obstacles représentés par le caractère X (uniquement les obstacles X). Lorsqu’un obstacle est détruit, il le reste définitivement et Blunder conserve sa direction. Si Blunder est en mode Casseur et qu’il passe à nouveau sur une bière, il perd aussitôt son mode Casseur. Les bières restent en place après le passage de Blunder.
# 2 téléporteurs T peuvent être présents dans la ville. Si Blunder passe sur un téléporteur, il est automatiquement téléporté à la position de l’autre téléporteur et il conserve ses propriétés de direction et de mode casseur.
# Finalement, les caractères espace représentent les zones vides de la carte (aucun comportement particulier autre que ceux spécifiés précédemment).

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
puts "Which problem to solve? [1-12]"
print ">"
input = gets.chomp

rows = problems[input.to_i]

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
p "target: #{target} - bottles #{bottles} - teleport #{teleport} - blunder: #{blunder}"

blunder_path = []
i = 0
loop_breaker = 300
loop do
  puts "----------------\nturn #{i}\n"
  puts rows
  puts "\n"
  p blunder
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

  puts output.upcase
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
  input = gets.chomp
  break if i >= loop_breaker || blunder.stop == true || input == "q"
end

if blunder.stop == true
  puts "you found Blunder path"
  blunder_path.each { |path| puts path }
elsif i >= loop_breaker
  puts "Blunder is stuck in a loop"
  puts "LOOP"
else
  puts "something's wrong"
end
