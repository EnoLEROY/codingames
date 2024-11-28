# Auto-generated code below aims at helping you parse
# the standard input according to the problem statement.

n = gets.to_i
file = []
n.times do
  cgxline = gets.chomp
  STDERR.puts "#{cgxline}"
  file << cgxline
end

parse_file = []
decalage = 0
file.each_with_index do |line, j|
    line.strip.split('').each_with_index do |char, i|
        if char == "("
            if line.strip.split('')[i+1] == ")" && line.strip.split('')[i+2] == "'"
                parse_file << "("
            else 
                if !parse_file[-1].nil?
                    parse_file << "\n" if "azertyuiopmlkjhgfdsqwxcvbn'=1234567890) ".include?(parse_file[-1].downcase)
                end
                decalage.times { parse_file << "    " }
                parse_file << "(\n"
                decalage += 1
            end
        elsif char == ")"
            if line.strip.split('')[i-1] == "(" && line.strip.split('')[i+1] == "'"
                parse_file << ")"
            else 
                decalage -= 1
                if !parse_file[-1].nil?
                    parse_file << "\n" if "azertyuiopmlkjhgfdsqwxcvbn'=1234567890) ".include?(parse_file[-1].downcase)
                end
                decalage.times { parse_file << "    " }
                parse_file << ")"
            end
        elsif char == ";"
            parse_file << ";"
            parse_file << "\n"
        elsif char == " "
            if !parse_file[-1].nil?
                # parse_file << char if !"=".include?(parse_file[-1])
            end
            # decalage.times { parse_file << "    " } if !"azertyuiopmlkjhgfdsqwxcvbn'=1234567890".include?(parse_file[-1].downcase)
            parse_file << char if (!"(=;".include?(line.strip.split('')[i-1]) && !")".include?(line.strip.split('')[i+1]))

        elsif char == "'" 
            if ")".include?(line.strip.split('')[i-1])
                STDERR.puts "if 1"
                if !parse_file[-1].nil?
                    parse_file << char if " )azertyuiopmlkjhgfdsqwxcvbn=1234567890".include?(parse_file[-1])
                else 
                    parse_file << char
                end 
            else 
                STDERR.puts "if 2"
                if !parse_file[-1].nil?
                    decalage.times { parse_file << "    " } if !"azertyuiopmlkjhgfdsqwxcvbn'=1234567890 ".include?(parse_file[-1].downcase)
                end
                parse_file << char
            end 
            STDERR.puts "je suis : #{line.strip.split('')[i-1]}"
            STDERR.puts "je suis : #{line}"
        else
            if !parse_file[-1].nil?
                decalage.times { parse_file << "    " } if !"azertyuiopmlkjhgfdsqwxcvbn='1234567890 ".include?(parse_file[-1].downcase)
            end
            parse_file << char
        end 
    end
end
STDERR.puts "#{parse_file}"

puts parse_file.join
