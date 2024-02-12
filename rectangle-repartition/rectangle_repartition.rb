# Auto-generated code below aims at helping you parse
# the standard input according to the problem statement.

w, h, count_x, count_y = gets.split(" ").collect { |x| x.to_i }
inputs = gets.split(" ")
colones = []
for i in 0..(count_x-1)
  x = inputs[i].to_i
  colones.push(x)
end
colones.push(w)
# puts "colones  #{colones}"
#####
lignes = []
inputs = gets.split(" ")
for i in 0..(count_y-1)
  y = inputs[i].to_i
  lignes.push(y)
end
lignes.push(h)
# puts "lignes #{lignes}"
####
# Write an answer using puts
# To debug: STDERR.puts "Debug messages..."

# ajout des inter
# j-i k-i l-i k-j l-j l-k

colones1 = colones
long = colones.length
for i in 0..(long - 1)
    for j in (i+1)..(long - 1)
    temp = colones1[j] - colones1[i]
    #puts "temp #{i} #{j} // #{colones1[j]} - #{colones1[j-1]} = #{temp}"
    colones.push(temp)
    end
end
# puts "colones ajout inter #{colones}"

lignes1 = lignes
long = lignes.length
for i in 0..(long - 1)
    for j in (i+1)..(long - 1)
    temp = lignes1[j] - lignes1[i]
    #puts "temp #{i} #{j} // #{lignes1[j]} - #{lignes1[j-1]} = #{temp}"
    lignes.push(temp)
    end
end
# puts "lignes ajout inter #{lignes}"

# faire les rectangles et savoir si condition carré ok
result = 0
for i in 0..(colones.length - 1)
    for j in 0..(lignes.length - 1)
        if colones[i] == lignes[j]
            result = result + 1
        end
    end
end

puts result
