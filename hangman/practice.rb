# looking to find every index of a character in a string

def all_indices(string, letter)
  array = string.split("")
  indices = []
  array.each_with_index do |char, idx|
    if char == letter
      indices << idx
    end
  end
  indices
end

puts all_indices("hellohowareyou", "h")