# Auto-generated code below aims at helping you parse
# the standard input according to the problem statement.

plain_text_1 = "LOREM IPSUM DOLOR SIT AMET CONSECTETUR ADIPISCING ELIT SED DO EIUSMOD OR INCIDIDUNT UT LABORE ET DOLORE MAGNA ALIQUA appairageOR COMMODO ULLAMCORPER A LACUS VESTIBULUM SED ARCU NON ODIO"
cipher_text_1 = "FRGLRCFTIAECIGRTRCFQCAFTGCGTGIAFQCCCQTSAIAQDIAAOMIRRMICACIKACSEMGTWTOSRROQQCCCRELXXHRMTMTOXQTUALYFUITSSHTXHLSWEVSSZUTBATSEASGWEQWTPAOKMBTMOBREGXILUYXLHGZBMR"
cipher_text_2 = "QADFFQKECOQAHZERHWRIIA"

# Write an answer using puts
# To debug: STDERR.puts "Debug messages..."

# remaniment du text
plain_text_1 = plain_text_1.split('')
plain_text_1.delete_if { |a| a == " "}
plain_text_1.map! { |a| a == "J" ? "I" : a }
cipher_text_1 = cipher_text_1.split('')

# cle matrice de 5 par 5

appairage = []
for i in 0...(plain_text_1.length / 2)
  appairage << [plain_text_1[i*2], cipher_text_1[i]]
end

p appairage.uniq!

key_lines = [[], [], [], [], []]
i = 0
5.times do
  if i == 0
    key_lines[i] = [appairage[0][0]]
  else
    deleted = key_lines.flatten.split('').uniq.map do |a|
      a unless to_delete.include?(a)
    end
    key_lines[i] = deleted[0]
  end

  appairage.each do |pair|
    p pair
    puts key_lines[i].class
    key_lines[i] << pair[0] if key_lines[i].include?pair[1]
    key_lines[i] << pair[1] if key_lines[i].include?pair[0]
    p key_lines[i]
  end
  to_delete = key_lines.flatten.split('').uniq
  p to_delete
  i+=1
end
key_lines.map! do |t|
  a = t.split('')
  a.uniq!
end

p key_lines
