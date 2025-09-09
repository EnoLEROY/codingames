
l, c, n = gets.split.map { |x| x.to_i }
queue = []
n.times do
  pi = gets.to_i
  queue << pi
end
STDERR.puts "#{l}, #{c}, #{n}"
# STDERR.puts "#{queue}"
# STDERR.puts "place #{l}, nb tours #{c}"

# temp = []
# 4.times do 
#   queue.each do |x|
#     temp << x
#   end
# end

# queue = Array.new(temp)

# STDERR.puts "#{queue}"
STDERR.puts "#{queue.sum}"

money = 0
place = l
if c < 100000
  STDERR.puts "option 1"
  onboarding = true
  # turns = c
  group_length = 20
  
  c.times do
    temp = []
    while onboarding && queue.length != 0
      groupes_sum = queue[0...group_length].sum 
      groupes = queue[0...group_length]
      group = queue[0]
      if place >= groupes_sum
        place -= groupes_sum
        money += groupes_sum
        if queue.length >= group_length
          temp << groupes
          queue.slice!(group_length..-1)
        else 
          temp = Array.new(queue)
          queue = []
        end
        # STDERR.puts "goupe #{group}/#{place} #{money} || #{queue} #{temp}"
      elsif place >= group
        # STDERR.puts "ca passe #{group}/#{place} #{money} || #{queue} #{temp}"
        place -= group
        money += group
        queue.delete_at(0)
        temp << group
      else 
        onboarding = false
      end
    end 
    temp.flatten!
    queue << temp
    queue.flatten!
    # turns -= 1
    # STDERR.puts "#{group}/#{place} (#{money})"
    # STDERR.puts "Ca passe pas"
    place = l
    onboarding = true
  end
  
  puts money
else 
  STDERR.puts "option 2"
  onboarding = true
  # turns = c
  group_length = 100
  differants_groups = []
  turn = c
  c.times do
    temp = []
    while onboarding && queue.length != 0
      # groupes_sum = queue[0...group_length].sum 
      # groupes = queue[0...group_length]
      group = queue[0]
      groupes = queue.slice!(0...group_length)
      groupes_sum = groupes.sum
      if place >= groupes_sum
        STDERR.puts 'groupe'
        place -= groupes_sum
        money += groupes_sum
        temp << groupes
        # STDERR.puts "goupe #{group}/#{place} #{money} || #{queue} #{temp}"
      elsif place >= group
        STDERR.puts 'Single'
        # STDERR.puts "ca passe #{group}/#{place} #{money} || #{queue} #{temp}"
        place -= group
        money += group
        queue.insert(0, groupes)
        queue.flatten!
        queue.delete_at(0)
        temp << group
      else 
        onboarding = false
      end
    end 
    temp.flatten!
    differants_groups << temp
    queue << temp
    queue.flatten!

    # STDERR.puts "#{group}/#{place} (#{money})"
    # STDERR.puts "Ca passe pas"
    STDERR.puts turn
    place = l
    onboarding = true
    turn -= 1
    
    
    # STDERR.puts differants_groups[0] == temp
    if differants_groups[0] == temp && differants_groups.length > 2
      STDERR.puts "dans la reprtition de groupes"
      taille = turn / differants_groups.length
      money_per_groups = differants_groups.map { |x| x.sum}
      groups = money_per_groups * (taille + 1)
      STDERR.puts differants_groups.length
      STDERR.puts turn
      STDERR.puts groups.length
      t = groups[0...(turn-2)].sum
      STDERR.puts "t = #{t}"
      # k = groups.flatten.sum
      # STDERR.puts "k = #{k}"
      money += t
      puts money
      STDERR.puts "apres money"
      break
    end
  end

  puts money
end

  
