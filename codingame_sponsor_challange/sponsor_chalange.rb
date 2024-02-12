STDOUT.sync = true # DO NOT REMOVE
# Auto-generated code below aims at helping you parse
# the standard input according to the problem statement.

first_init_input = gets.to_i
STDERR.puts "first #{first_init_input}"
second_init_input = gets.to_i
STDERR.puts "second #{second_init_input}"
third_init_input = gets.to_i
STDERR.puts "third #{third_init_input}"

# game loop
i = 0
loop do
  STDERR.puts "initials: #{first_init_input}, #{second_init_input}, #{third_init_input}"
  temp1 = []
  first_input = gets.chomp
  second_input = gets.chomp
  third_input = gets.chomp
  fourth_input = gets.chomp
  temp1 << first_input
  temp1 << second_input
  temp1 << third_input
  temp1 << fourth_input
  STDERR.puts "temp1: #{temp1}"
  temp2 = []
  third_init_input.times do
    fifth_input, sixth_input = gets.split(" ").collect { |x| x.to_i }
    temp2 << [fifth_input, sixth_input]
  end
  STDERR.puts "temp2 #{temp2}"

  # Write an action using puts
  # To debug: STDERR.puts "Debug messages..."
  # output "A, B, C, D or E"
  answer = ["A", "B", "C", "D", "E"]
  puts answer[i%5]
  i += 1
end
