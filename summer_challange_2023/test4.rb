# exemple :
# instructions = ["BACK", "TURN RIGHT", "FORWARD", "TURN RIGHT", "FORWARD", "FORWARD", "FORWARD", "FORWARD"]
# target = [-1, 4]

# single possibility
instructions = ["FORWARD", "FORWARD", "FORWARD", "TURN RIGHT", "TURN RIGHT", "TURN RIGHT", "BACK", "TURN LEFT", "TURN LEFT", "FORWARD"]
target = [-1, -1]


CLOCK_ROTATION = ["RIGHT", "DOWN", "LEFT", "UP"]
POSSIBLE_INSTRUCTIONS = ["FORWARD", "BACK", "TURN RIGHT", "TURN LEFT"]

def right_path?(instructions, target)
  player = [0, 0, "RIGHT"]

  instructions.each do |instruction|
    case instruction
    when "TURN RIGHT"
      temp = CLOCK_ROTATION.index(player[2])
      player[2] = CLOCK_ROTATION[(temp + 1) % CLOCK_ROTATION.length]
    when "TURN LEFT"
      temp = CLOCK_ROTATION.index(player[2])
      player[2] = CLOCK_ROTATION[(temp - 1) % CLOCK_ROTATION.length]
    when "FORWARD"
      case player[2]
      when "RIGHT"
        player[0] += 1
      when "LEFT"
        player[0] -= 1
      when "UP"
        player[1] += 1
      when "DOWN"
        player[1] -= 1
      else
        p "probleme forward"
        p player
        raise
      end
    when "BACK"
      case player[2]
      when "RIGHT"
        player[0] -= 1
      when "LEFT"
        player[0] += 1
      when "UP"
        player[1] -= 1
      when "DOWN"
        player[1] += 1
      else
        p "probleme back"
        raise
      end
    else
      p "probleme instruction"
      p player
      raise
    end
    p player
  end
  return target == [player[0], player[1]]
end
p right_path?(instructions, target)
p "--------------------------------"


def find_correct_path(instructions, target)
  # Write your code here
  for i in 0...instructions.length
    current_instructions = Array.new(instructions)
    POSSIBLE_INSTRUCTIONS.each do |possiblity|
      current_instructions[i] = possiblity
      # p current_instructions
      p right_path?(current_instructions, target)

      return "Replace instruction #{i+1} with #{current_instructions[i]}" if right_path?(current_instructions, target)
    end
  end

  p "probleme dnas le programe"
end

puts find_correct_path(instructions, target)
