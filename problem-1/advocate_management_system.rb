require 'json'
require './process_helper'
OPTION_MAPPING = JSON.parse(File.read('./constants.json'))

class AdvocateManagementSystem
  include ProcessHelper
end

puts %q(Options:
  1. Add an advocate
  2. Add junior advocates
  3. Add states for advocate
  4. Add cases for advocate
  5. Reject a case.
  6. Display all advocates
  7. Display all cases under a state
  Note: Type exit to quit the Advocate Management System
-----------------------------------------------------------
)
loop do
  puts "Input:"
  option = gets.chomp
  break if option == 'exit'
  map = OPTION_MAPPING[option].to_h
  inputs = {'method' => map['method']}
  unless map['inputs']
    puts "Please enter a valid option"
    next
  end
  map['inputs'].each do |variable, display_name|
    puts display_name
    inputs[variable] = gets.chomp
  end
  AdvocateManagementSystem.new.process(inputs)
  puts ('-' * 100)
end