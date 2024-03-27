def distance(start, finish)
  Math.sqrt((finish[:x] - start[:x]) ** 2 + (finish[:y] - start[:y]) ** 2)
end

def coords_within_distance(start, distance)

end

search_range = ((center[0] - (radius + 1))..(center[0] + (radius + 1)))
for row_id in search_range
  for column_id in search_range
    distance = distance({ x: center[0], y: center[1] }, { x: row_id, y: column_id })
    if distance >= radius && distance < (radius + 1)
      characters << image[row_id][column_id]
      cardinal_points << [row_id, column_id] if center[0] == row_id || center[1] == column_id
    end
  end
end


image.each_with_index do |row, row_id|
  row.split('').each_with_index do |column, column_id|
    distance = distance({ x: center[0], y: center[1] }, { x: row_id, y: column_id })
    if distance >= radius && distance < (radius + 1)
      characters << column
      cardinal_points << [row_id, column_id] if center[0] == row_id || center[1] == column_id
    end
  end
end