s = "37 21 37 27 16 29"


DECODE = {
  "Q"=> "E",
  "T"=> "R",
  "L"=> "O",
  "V"=> "Y",
  "R"=> "U",
  "F"=> "T",
  "O"=> "N",
  "B"=> "P",
  "K"=> "D",
  "U"=> "W",
  "E"=> "L",
  "X"=> "F",
  "Y"=> "I",
  "H"=> "G",
  "P"=> "H",
  "W"=> "S",
  "J"=> "C",
  "N"=> "M",
  "I"=> "B",
  "A"=> "A",
  " "=> " ",
  ","=> ",",
  "."=> ".",
  "!"=> "!",
  ":"=> ":"
}
# ""=> "",
# ""=> "",
# ""=> "",
# ""=> "",
# ""=> "",

error1 = "QTTLT : Vlrt jlkq wplrek tqfrto RB, KLUO, EQXF lt TYHPF."
error2 = "Fynqlrf!"
error3 = "Vlr uqtq jarhpf iv ao qoqnv..."
error4 = "Jlohtafreafylow!"

def decript(string)
  characters = string.split('')
  sentence = []
  decripted = []
  not_decripted = []

  characters.each do |letter|
    if !DECODE[letter.capitalize].nil?
      output = DECODE[letter.capitalize]
      sentence << output
      decripted << output.downcase
      not_decripted << "*"
    else
      sentence << letter.downcase
      decripted << "-"
      not_decripted << letter
    end
  end

  puts decripted.join
  puts not_decripted.join
  return sentence.join
end

puts decript(error1)
puts '-----------------------'
puts decript(error2)
puts '-----------------------'
puts decript(error3)
puts '-----------------------'
puts decript(error4)




# SUCCESSFUL :

# output = ["0",                 "UP",                "DOWN",              "RIGHT",             "UP",                "DOWN",              "RIGHT",             "UP",                "DOWN",              "RIGHT"]
# inputs = ["37 21 37 27 16 29", "36 22 36 28 16 30", "35 23 35 29 16 29", "34 24 34 29 17 29", "33 25 33 30 17 30", "32 26 32 29 17 29", "31 27 31 29 18 29", "30 28 30 30 18 30", "29 29 29 29 18 29"]


# Game information:

# 28 121 115 55 115 51 115 51 116 55 28 120 115 94

# 29 120 115 56               115 56 29 119 115 93

# 30 119                             30 118 116 93

# game 3 SUCCESSFUL
# ["UP", "DOWN", "RIGHT", "LEFT", "UP", "DOWN", "RIGHT", "LEFT", "UP", "DOWN", "RIGHT", "LEFT", "UP", "DOWN", "RIGHT", "LEFT", "UP", "DOWN", "RIGHT", "LEFT", "UP", "DOWN", "RIGHT", "LEFT", "UP", "DOWN", "RIGHT", "LEFT", "UP", "DOWN", "RIGHT", "LEFT", "UP", "DOWN", "RIGHT", "LEFT", "UP", "DOWN", "RIGHT", "LEFT", "UP", "DOWN", "RIGHT", "LEFT", "UP", "DOWN", "RIGHT", "LEFT", "UP", "DOWN", "RIGHT", "LEFT", "UP", "DOWN", "RIGHT", "LEFT", "UP", "DOWN", "RIGHT", "LEFT", "UP", "DOWN", "RIGHT", "LEFT", "UP", "DOWN", "RIGHT", "LEFT", "UP", "DOWN", "RIGHT", "LEFT", "UP", "DOWN", "RIGHT", "LEFT", "UP", "DOWN", "RIGHT", "LEFT", "UP", "DOWN", "RIGHT", "LEFT", "UP", "DOWN", "RIGHT", "LEFT", "UP", "DOWN", "RIGHT", "LEFT", "UP", "DOWN", "RIGHT", "LEFT", "UP", "DOWN"]
# ["-42 191 184 -15 184 -19 185 -19 186 -15 -42 190 92 93", "-41 190 183 -14 183 -18 184 -18 185 -14 -41 189 92 94", "-40 189 182 -13 182 -17 183 -17 184 -13 -40 188 92 93", "-39 188 181 -12 181 -16 182 -16 183 -12 -39 187 93 93", "-38 187 ...
# Game information:


# game 4 echeque

# ["UP", "DOWN", "RIGHT", "LEFT", "UP", "DOWN", "RIGHT", "LEFT", "UP", "DOWN", "RIGHT", "LEFT", "UP", "DOWN", "RIGHT", "LEFT", "UP", "DOWN", "RIGHT", "LEFT", "UP", "DOWN", "RIGHT", "LEFT", "UP", "DOWN", "RIGHT", "LEFT", "UP", "DOWN", "RIGHT", "LEFT", "UP", "DOWN", "RIGHT", "LEFT", "UP", "DOWN", "RIGHT", "LEFT", "UP", "DOWN", "RIGHT", "LEFT", "UP", "DOWN", "RIGHT", "LEFT", "UP", "DOWN", "RIGHT", "LEFT", "UP", "DOWN", "RIGHT", "LEFT", "UP", "DOWN", "RIGHT"]
# ["42 34 33 118 -3 178 151 29 42 59 0 178 106 29 33 65 149 87", "43 35 34 117 -2 177 150 30 43 60 1 177 107 30 34 66 149 88", "44 36 35 116 -1 176 149 31 44 61 2 176 108 31 35 67 149 87", "45 37 36 115 0 175 150 32 45 62 3 175 109 32 36 68 150 87", "46 38 37 114 1 174 150 33 46 63 4 174 110 33 37 69 150 88", "47 39 38 113 2 173 150 34 47 64 5 173 111 34 38 70 150 87", "48 40 39 112 3 172 151 35 48 65 6 172 112 35 39 71 151 87", "49 41 40 111 4 171 151 36 49 66 7 171 113 36 40 72 151 88", "50 42 41 110 5 170 151 37 50 67 8 170 114 37 41 73 151 87", "51 43 42 109 6 169 152 38 51 68 9 169 115 38 42 74 152 87", "52 44 43 108 7 168 152 39 52 69 10 168 116 39 43 75 152 88", "53 45 44 107 8 167 152 40 53 70 11 167 117 40 44 76 152 87", "54 46 45 106 9 166 153 41 54 71 12 166 118 41 45 77 153 87", "55 47 46 105 10 165 153 42 55 72 13 165 119 42 46 78 153 88", "56 48 47 104 11 164 153 43 56 73 14 164 120 43 47 79 153 87", "57 49 48 103 12 163 154 44 57 74 15 163 121 44 48 80 154 87", "58 50 49 102 13 162 154 45 58 75 16 162 122 45 49 81 154 88", "59 51 50 101 14 161 154 46 59 76 17 161 123 46 50 82 154 87", "60 52 51 100 15 160 155 47 60 77 18 160 124 47 51 83 155 87", "61 53 52 99 16 159 155 48 61 78 19 159 125 48 52 84 155 88", "62 54 53 98 17 158 155 49 62 79 20 158 126 49 53 85 155 87", "63 55 54 97 18 157 156 50 63 80 21 157 127 50 54 86 156 87", "64 56 55 96 19 156 156 51 64 81 22 156 128 51 55 87 156 88", "65 57 56 95 20 155 156 52 65 82 23 155 129 52 56 87 156 87", "66 58 57 94 21 154 157 53 66 83 24 154 130 53 57 87 157 87", "67 59 58 93 22 153 157 54 67 84 25 153 131 54 58 88 157 88", "68 60 59 92 23 152 157 55 68 85 26 152 132 55 59 87 157 87", "69 61 60 91 24 151 158 56 69 86 27 151 133 56 60 87 158 87", "70 62 61 90 25 150 158 57 70 87 28 150 134 57 61 88 158 88", "71 63 62 89 26 149 158 58 71 87 29 149 135 58 62 87 158 87", "72 64 63 88 27 148 159 59 72 87 30 148 136 59 63 87 159 87", "73 65 64 88 28 147 159 60 73 88 31 147 137 60 64 88 159 88", "74 66 29 146 159 61 74 87 32 146 138 61 159 87", "75 67 30 145 160 62 75 87 33 145 139 62 160 87", "76 68 31 144 160 63 76 88 34 144 140 63 160 88", "77 69 32 143 160 64 77 87 35 143 141 64 160 87", "78 70 33 142 161 65 78 87 36 142 142 65 161 87", "79 71 34 141 161 66 79 88 37 141 143 66 161 88", "80 72 35 140 161 67 80 87 38 140 144 67 161 87", "81 73 36 139 162 68 81 87 39 139 145 68 162 87", "82 74 37 138 162 69 82 88 40 138 146 69 162 88", "83 75 38 137 162 70 83 87 41 137 147 70 162 87", "84 76 39 136 163 71 84 87 42 136 148 71 163 87", "85 77 40 135 163 72 85 88 43 135 149 72 163 88", "86 78 41 134 163 73 86 87 44 134 150 73 163 87", "87 79 42 133 164 74 87 87 45 133 151 74 164 87", "88 80 43 132 164 75 88 88 46 132 152 75 164 88", "89 81 44 131 164 76 89 87 47 131 153 76 164 87", "90 82 45 130 165 77 90 87 48 130 154 77 165 87", "91 83 46 129 165 78 91 88 49 129 155 78 165 88", "92 84 47 128 165 79 92 87 50 128 156 79 165 87", "93 85 48 127 166 80 93 87 51 127 157 80 166 87", "94 86 49 126 166 81 94 88 52 126 158 81 166 88", "95 87 50 125 166 82 95 87 53 125 159 82 166 87", "51 124 167 83 54 124 160 83 167 87", "52 123 167 84 55 123 161 84 167 88", "53 122 167 85 56 122 162 85 167 87", "54 121 168 86 57 121 163 86 168 87", "55 120 168 87 58 120 164 87 168 88"]
# Game information:



STDOUT.sync = true # DO NOT REMOVE
# Auto-generated code below aims at helping you parse
# the standard input according to the problem statement.
DECODE = {
  "Q"=> "E",
  "T"=> "R",
  "L"=> "O",
  "V"=> "Y",
  "R"=> "U",
  "F"=> "T",
  "O"=> "N",
  "B"=> "P",
  "K"=> "D",
  "U"=> "W",
  "E"=> "L",
  "X"=> "F",
  "Y"=> "I",
  "H"=> "G",
  "P"=> "H",
  "W"=> "S",
  "J"=> "C",
  "N"=> "M",
  "I"=> "B",
  "A"=> "A",
  " "=> " ",
  ","=> ",",
  "."=> ".",
  "!"=> "!",
  ":"=> ":"
}

error1 = "QTTLT : Vlrt jlkq wplrek tqfrto RB, KLUO, EQXF lt TYHPF."
error2 = "Fynqlrf!"
error3 = "Vlr uqtq jarhpf iv ao qoqnv..."
error4 = "Jlohtafreafylow!"

def decript(string)
  characters = string.split('')
  sentence = []
  decripted = []
  not_decripted = []

  characters.each do |letter|
    if !DECODE[letter.capitalize].nil?
      output = DECODE[letter.capitalize]
      sentence << output
      decripted << output.downcase
      not_decripted << "*"
    else
      sentence << letter.downcase
      decripted << "-"
      not_decripted << letter
    end
  end

  puts decripted.join
  puts not_decripted.join
  return sentence.join
end

class Entity
  attr_accessor :x, :y, :color

  def initialize(x, y, color)
    @x = x
    @y = y
    @color = color
  end

  def deplacement(direction)
    case deplacement
    when "RB"
  end
end

# game loop
i = 0
soluce = []
inputs = []
loop do
  s = gets.chomp
  STDERR.puts s
  temp = s.split(' ')
  entity1 = Entity.new(temp[0], temp[1], "BLUE")
  entity2 = Entity.new(temp[2], temp[3], "BLUE")
  enemmy = Entity.new(temp[4], temp[5], "RED")


  answers_decript = ["UP", "DOWN", "RIGHT", "LEFT"]
  answers = ["RB", "KLUO", "TYHPF", "EQXF"]

  # Write an action using puts
  # To debug: STDERR.puts "Debug messages..."
  output = answers[i%3]
  soluce << answers_decript[i%4]
  inputs << s
  STDERR.puts i
  STDERR.puts output

  STDERR.puts "#{soluce}"
  STDERR.puts "#{inputs}"

  i += 1
  puts output
end
