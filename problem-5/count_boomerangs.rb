require 'json'

def count_boomerangs(input)
  # Get 2 consecutive elements of each element as array and select only if it satifies boomerang condition
  input.each_cons(3).select{ |slice| slice[0] == slice[2] && slice[0] != slice[1] }.length
end

puts "Enter input:"
input = JSON.parse(gets).to_a rescue (puts "Invalid input"; return [])
puts "Output:"
p count_boomerangs(input)