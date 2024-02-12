# test 1
connections = [[0, 2], [2, 4], [2, 1], [1, 3], [3, 4]]
n_gears = 5

# tree systeme
connections = [[9, 7], [6, 0], [5, 6], [9, 0], [2, 8], [4, 5], [6, 8], [3, 6], [9, 1]]
n_gears = 10

def gear_balance(n_gears, connections)
  # Write your code here
  # true = clockwise, false = conterclockwise
  gears = { 0 => true}
  connections.map! { |pair| pair.sort! }
  connections.sort!
  p connections
  connections.each do |connection|
    p connections
    p gears
    if gears.keys.include?(connection[0]) && !gears.keys.include?(connection[1])
      p 'if 1'
      gears[connection[1]] = !gears[connection[0]]
    elsif gears.keys.include?(connection[1]) && !gears.keys.include?(connection[0])
      p 'if 2'
      gears[connection[0]] = !gears[connection[1]]
    elsif gears.keys.include?(connection[0]) && gears.keys.include?(connection[1])
      p 'if 3'
      p connection
      return [-1, -1] if gears[connection[1]] == gears[connection[0]]
    else
      p 'if 4'
      connections << connection
    end
  end
  p gears
  clockwise = []
  counterclokwise = []

  gears.each do |key, value|
    if value
      clockwise << key
    else
      counterclokwise << key
    end
  end

  # p clockwise
  # p counterclokwise
  return [clockwise.length, counterclokwise.length]
end


p gear_balance(n_gears, connections)
# gear 0 clockwise
# outout [clokwise, counterclokwise]
# si impossible [-1, -1]
