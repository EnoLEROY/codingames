require 'json'
require 'ostruct'


# @param [Integer] The height of the image.
# @param [Integer] The width of the image.
# @param [Array<String>] Pixels of the image, given row by row from top to bottom. All pixel colors are alphanumeric.
# @return [Integer] The total length of wire needed to deploy the network (modulo 10^9+7)
def get_cable_length(n_rows, n_cols, image)
  # Write your code here
  time = Time.now
  chars = {}
  image.join.split('').uniq.each do |char|
    chars[char] = []
  end
  STDERR.puts Time.now - time
  
  time = Time.now
  image.each_with_index do |row, row_id|
    row.split('').each_with_index do |char, char_id|
      chars[char] << [row_id, char_id]
    end
  end
  STDERR.puts Time.now - time
  # STDERR.puts chars

  cable = []
  chars.each do |char, indexes|
    for i in (0...indexes.length)
      for j in (i...indexes.length)
        cable << (indexes[i][0] - indexes[j][0]).abs
        cable << (indexes[i][1] - indexes[j][1]).abs
      end
    end
  end
  # STDERR.puts "#{cable}"
  return cable.sum * 2
end

longest = chars.values.sort {|x,y| x.length <=> y.length}.last.length


cable = []
for i in (0...longest)
  for j in (i...longest)
    
    cable << (indexes[i][0] - indexes[j][0]).abs
    cable << (indexes[i][1] - indexes[j][1]).abs
  end
end