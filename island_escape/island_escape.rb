# Auto-generated code below aims at helping you parse
# the standard input according to the problem statement.

n = gets.to_i
map = []
n.times do
  inputs = gets.split
  row = []
  for j in 0..(n-1)
    elevation = inputs[j].to_i
    row << elevation
  end
  map << row
end


STDERR.puts "#{map}" 
map.each do |i|
  STDERR.puts i.inspect
end

start_point = {
  x: n/2,
  y: n/2,
  elevation: map[n/2][n/2]
}
path = []

def can_you_move?(array, you)

  # adjacent_plots = {
  #   north: { 
  #     x: you[:x]-1,
  #     y: you[:y],
  #     elevation: array[you[:x]-1][you[:y]]
  #   },
  #   south: { 
  #     x: you[:x]+1,
  #     y: you[:y],
  #     elevation: array[you[:x]+1][you[:y]]
  #   },
  #   west: { 
    #     x: you[:x],
  #     y: you[:y]-1,
  #     elevation: array[you[:x]][you[:y]-1]
  #   },
  #   east: { 
  #     x: you[:x],
  #     y: you[:y]+1,
  #     elevation: array[you[:x]][you[:y]+1]
  #   }
  # }

  adjacent_plots = [
    { 
      x: you[:x]-1,
      y: you[:y],
      elevation: array[you[:x]-1][you[:y]]
    },
    { 
      x: you[:x]+1,
      y: you[:y],
      elevation: array[you[:x]+1][you[:y]]
    },
    { 
      x: you[:x],
      y: you[:y]-1,
      elevation: array[you[:x]][you[:y]-1]
    },
    { 
      x: you[:x],
      y: you[:y]+1,
      elevation: array[you[:x]][you[:y]+1]
    }
  ]
  attainable_plots = []
  adjacent_plots.each do |plot|
    # STDERR.puts plot.inspect
    # STDERR.puts plot[:elevation] - you[:elevation]
    if (plot[:elevation] - you[:elevation]).abs <= 1
      attainable_plots << plot
    end
  end
  
  # STDERR.puts you.inspect
  # STDERR.puts "attainable_plots"
  # STDERR.puts attainable_plots.inspect
  return attainable_plots
end

plots_to_test = can_you_move?(map, start_point)
STDERR.puts "plots_to_test"
STDERR.puts plots_to_test.inspect

STDERR.puts map.size

answer = []
tested_plots = []
# plots_to_test.each do |plot|
# plots_to_test.length >= ( map[0].length * map.length ) ||
until answer.size > 0 || plots_to_test.size == 0
  plot = plots_to_test[0]
  tested_plots << plot 
  # STDERR.puts "plot"
  # STDERR.puts plot.inspect
  if plot[:elevation] == 0 
    answer << "yes"
  else 
    # STDERR.puts plots_to_test.inspect 

    # STDERR.puts plots_to_test.inspect 
    # STDERR.puts "----------"
    plots_to_test << can_you_move?(map, plot)
    plots_to_test.flatten!
    plots_to_test = Array.new(plots_to_test.uniq)
    tested_plots.each do |tested_plot|
      plots_to_test.delete(tested_plot)
    end
  end
  STDERR.puts answer.inspect
  STDERR.puts "plots test#{plots_to_test.size}/ #{map.size}"
  STDERR.puts tested_plots.inspect
end
      
STDERR.puts answer.inspect
if answer.uniq[0] == "yes"
  puts "yes"
else
  puts "no"
end
      

# Write an answer using puts
# To debug: STDERR.puts "Debug messages..."
