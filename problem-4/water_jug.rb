require 'json'

def water_jug(inputs)
  capacity = inputs[0].map(&:to_i)
  target = inputs[1].map(&:to_i)
  outcome_list = [[0,0,capacity[2]]]
  counter = 0
  status_list = [[0,0,capacity[2]]]
  until outcome_list.empty?
    counter += 1
    new_outcome_list = []
    outcome_list.each do |a, b, c|
      new_outcome_list.push([0, b, c]) # Empty A
      new_outcome_list.push([a, 0, c]) # Empty B
      new_outcome_list.push([a, b, 0]) # Empty C
      new_outcome_list.push([capacity[0], b, c]) # Fill A
      new_outcome_list.push([a, capacity[1], c]) # Fill B
      new_outcome_list.push([a, b, capacity[2]]) # Fill C
      new_outcome_list.push([[(a - (capacity[1] - b)),0].max, [(b + a), capacity[1]].min, c]) # A to B
      new_outcome_list.push([[(a - (capacity[2] - c)),0].max, b, [(c + a), capacity[2]].min]) # A to C
      new_outcome_list.push([[(b + a), capacity[0]].min, [(b - (capacity[0] - a)),0].max, c]) # B to A
      new_outcome_list.push([a, [(b - (capacity[2] - c)),0].max, [(c + b), capacity[2]].min]) # B to C
      new_outcome_list.push([[(c + a), capacity[0]].min, b, [(c - (capacity[0] - a)),0].max]) # C to A
      new_outcome_list.push([a, [(c + a), capacity[1]].min, [(c - (capacity[1] - b)),0].max]) # C to B
    end
    new_outcome_list = new_outcome_list.uniq.compact - status_list
    return 'No solution.' if new_outcome_list.empty?
    return counter if new_outcome_list.include?(target)
    outcome_list = new_outcome_list
    status_list += new_outcome_list
  end
  'No solution.'
end

puts "Enter inputs:"
inputs = JSON.parse("[#{gets.chomp}]").to_a rescue (puts "Invalid inputs"; return [])
puts "Output:"
p water_jug(inputs)