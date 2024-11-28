def formating(file)
  tab = "    "
  formated_file = []
  # file.map! do |line|
  #   line.strip
  # end
  
  tab_counter = 0
  
  file = file.join("\n")
  string = false

  file.split('').each_with_index do |char, char_id|
    if char == "'"
      string = !string
    end

    if string 
      formated_file << char
    else
      if !"()=; ".include?(char) && char != "\t" && char != "\n"
        formated_file << char
      end
      
      if char == " "
        if string 
          formated_file << char
        end
      end
      
      if char == "\t"
        if string
          formated_file << char
        end
      end
      
      if char == "\n"
        if string
          formated_file << char
        end
      end
      
      if char == "(" 
        if file[char_id+1] == ")" && "azertyuiopmlkjhgfdsqwxcvbn".include?(file[char_id-1])
          formated_file << char
        elsif search_for_next_char(file, char_id) == ")"
          formated_file << char
          tab_counter += 1
        else
          formated_file << char + "\n"
          tab_counter += 1
          formated_file << tab * tab_counter
        end
      end 
      
      if char == ")" 
        if file[char_id-1] == "(" && "azertyuiopmlkjhgfdsqwxcvbn".include?(file[char_id-2])
          formated_file << char
        else
          tab_counter -= 1
          formated_file << "\n" + tab * tab_counter + char 
          if search_for_next_char(file, char_id) != ";" && search_for_next_char(file, char_id) != ")"
            formated_file << "\n" + tab * tab_counter 
          end
        end
      end
      
      if char == ";"
        if file[char_id-1] == ")"
          formated_file << char + "\n" + tab * tab_counter
        else
          formated_file << char + "\n" + tab * tab_counter
        end
      end
      
      if char == "="
        if search_for_next_char(file, char_id) == "("
          formated_file << char + "\n" + tab * tab_counter
        else 
          formated_file << char 
        end
      end
    end
  end
    
  formated_file.join
end

def search_for_next_char(file, char_i)
  file.slice((char_i+1)..-1).strip.split('').first
end
