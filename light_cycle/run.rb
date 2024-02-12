STDOUT.sync = true # DO NOT REMOVE
# Auto-generated code below aims at helping you parse
# the standard input according to the problem statement.
def move(coords, off_limit_pos)
  x = coords[0]
  y = coords[1]
  a = nil
  if !off_limit_pos.include?([x+1, y]) && x < 28
    a = "RIGHT"
  elsif !off_limit_pos.include?([x-1, y]) && x > 0
    a = "LEFT"
  elsif !off_limit_pos.include?([x, y+1]) && y < 18
    a = "DOWN"
  elsif !off_limit_pos.include?([x, y-1]) && y > 0
    a = "UP"
  end
  return a
end


my_positions = []
your_positions = []
all_pos = []
# game loop
loop do
  # n: total number of players (2 to 4).
  # p: your player number (0 to 3).
  n, p = gets.split(" ").collect { |x| x.to_i }

  lightcycles = []
  n.times do
    # x0: starting X coordinate of lightcycle (or -1)
    # y0: starting Y coordinate of lightcycle (or -1)
    # x1: starting X coordinate of lightcycle (can be the same as X0 if you play before this player)
    # y1: starting Y coordinate of lightcycle (can be the same as Y0 if you play before this player)
    x0, y0, x1, y1 = gets.split(" ").collect { |x| x.to_i }
    lightcycles << [x1, y1]
  end

  me = lightcycles[p]
  you = lightcycles[n]

  my_positions << me
  your_positions << you
  all_pos << me
  all_pos << you


  puts move(me, all_pos)
end


["(\n", "    ", "'", "m", "e", "n", "u", "'", "=", "\n", "    ", "(\n", "    ", "    ", "'", "i", "d", "'", "=", "'", "f", "i", "l", "e", "'", ";", "\n", "    ", "    ", "'", "v", "a", "l", "u", "e", "'", "=", "'", "F", "i", "l", "e", "'", ";", "\n", "    ", "    ", "'", "p", "o", "p", "u", "p", "'", "=", "\n", "    ", "    ", "(\n", "    ", "    ", "    ", "'", "m", "e", "n", "u", "i", "t", "e", "m", "'", "=", "\n", "    ", "    ", "    ", "(\n", "    ", "    ", "    ", "    ", "(\n", "    ", "    ", "    ", "    ", "    ", " ", "'", "v", "a", "l", "u", "e", "'", "=", "'", "N", "e", "w", "'", ";", "\n", "    ", "    ", "    ", "    ", "    ", " ", "'", "o", "n", "c", "l", "i", "c", "k", "'", "=", "'", "C", "r", "e", "a", "t", "e", "N", "e", "w", "D", "o", "c", "\n", "    ", "    ", "    ", "    ", "    ", "(\n", "    ", "    ", "    ", "    ", "    ", ")", "    ", "    ", "    ", "    ", "    ", "'", " ", "\n", "    ", "    ", "    ", "    ", ")", ";", "\n", "    ", "    ", "    ", "    ", "(\n", "    ", "    ", "    ", "    ", "    ", " ", "'", "v", "a", "l", "u", "e", "'", "=", "'", "O", "p", "e", "n", "'", ";", "\n", "    ", "    ", "    ", "    ", "    ", " ", "'", "o", "n", "c", "l", "i", "c", "k", "'", "=", "'", "O", "p", "e", "n", "D", "o", "c", "\n", "    ", "    ", "    ", "    ", "    ", "(\n", "    ", "    ", "    ", "    ", "    ", ")", "    ", "    ", "    ", "    ", "    ", "'", " ", "\n", "    ", "    ", "    ", "    ", ")", ";", "\n", "    ", "    ", "    ", "    ", "(\n", "    ", "    ", "    ", "    ", "    ", " ", "'", "v", "a", "l", "u", "e", "'", "=", "'", "C", "l", "o", "s", "e", "'", ";", "\n", "    ", "    ", "    ", "    ", "    ", " ", "'", "o", "n", "c", "l", "i", "c", "k", "'", "=", "'", "C", "l", "o", "s", "e", "D", "o", "c", "\n", "    ", "    ", "    ", "    ", "    ", "(\n", "    ", "    ", "    ", "    ", "    ", ")", "    ", "    ", "    ", "    ", "    ", "'", " ", "\n", "    ", "    ", "    ", "    ", ")", "\n", "    ", "    ", "    ", ")", "\n", "    ", "    ", ")", ";", "\n", "    ", "    ", " ", "\n", "    ", "    ", "(\n", "    ", "    ", ")", "\n", "    ", ")", "\n", ")"]
(
