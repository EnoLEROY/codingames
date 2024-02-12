# 1
wish_a = 'laser eyes'
wish_b = 'telepathy'

def mix_wishes(wish_a, wish_b)
  # Write your code here
  a = wish_a.split('')
  p a
  b = wish_b.split('')
  p b

  letters_a = []
  letters_b = []
  word = []
  a.each do |letter_a|
    b.each do |letter_b|
      if letter_a == letter_b
        letters_a << a
        letters_b << a
        p a.index(letter_a)
        
      end
    end
  end

  p letters_a
  p letters_b.uniq
  return true
end

puts mix_wishes(wish_a, wish_b)
