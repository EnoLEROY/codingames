# r = 254 # the number to put in binary
# n = 5 # number of patterns
# start_pattern = ".....@....."

r = 90
n = 16
start_pattern = "...............@..............."


r_binary = r.to_s(2)
NEIGHBORHOODS = {
  "111" => r_binary[-8] || "0",
  "110" => r_binary[-7] || "0",
  "101" => r_binary[-6] || "0",
  "100" => r_binary[-5] || "0",
  "011" => r_binary[-4] || "0",
  "010" => r_binary[-3] || "0",
  "001" => r_binary[-2] || "0",
  "000" => r_binary[-1] || "0"
}

CODE = {
  "@" => "1",
  "." => "0",
  "1" => "@",
  "0" => "."
}


def next_pattern_in_binary(pattern_in_binary)
  next_pattern_in_binary = []
  symbols = pattern_in_binary.split('')
  symbols.each_with_index do |symbol, i|
    neighborhood = pattern_in_binary[(i - 1) % pattern_in_binary.length] + pattern_in_binary[i] + pattern_in_binary[(i + 1) % pattern_in_binary.length]
    next_pattern_in_binary << NEIGHBORHOODS[neighborhood.to_s]
  end
  return next_pattern_in_binary.join
end

def code(pattern)
  symbols = pattern.split('')
  pattern_out = []
  symbols.each do |symbol|
    pattern_out << CODE[symbol]
  end
  return pattern_out.join
end

pattern = start_pattern

n.times do
  puts pattern
  pattern_in_binary = code(pattern)
  next_pattern_in_binary = next_pattern_in_binary(pattern_in_binary)
  next_pattern = code(next_pattern_in_binary)
  pattern = next_pattern
end
