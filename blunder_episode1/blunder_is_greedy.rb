rooms = [["0", "200", "E", "E"]]

room = rooms[0]
money = 0
TOTALS = []
def total_money(room, money)
  money += room[1].to_i
  # salle 1
  if room[2] == "E"
    TOTALS << money
  else
    total_money(rooms[room[2].to_i], money)
  end

  # salle 2
  if room[3] == "E"
    TOTALS << money
  else
    total_money(rooms[room[3].to_i], money)
  end
end

total_money(room, money)
p TOTALS
