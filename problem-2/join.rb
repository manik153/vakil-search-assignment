require 'json'

def join(word_list)
  final_word = word_list[0]
  min_shared = word_list.map(&:length).max
  temp = final_word
  # Loop word_list except first, because it's used as default value for final_word
  word_list[1..-1].to_a.each do |word|
    until word.start_with?(temp)
      # Remove first letter
      temp = temp[1..-1]
      # Set temp as substring of temp whose starting character is start letter of word
      temp = temp[(temp.index(word[0]))..-1]
    end
    final_word += word[temp.length..-1].to_s
    min_shared = [min_shared, temp.length].min
    temp = final_word
  end
  [final_word,min_shared]
end

puts "Enter word list:"
word_list = JSON.parse(gets).to_a rescue (puts "Invalid list"; return [])
puts "Output:"
p join(word_list)

=begin
final_word        temp        word

oven              oven        envier
oven              en          envier

ovenvier          ovenvier    erase
ovenvier          envier      erase
ovenvier          er          erase

ovenvierase       ovenvierase serious
ovenvierase       se          serious

ovenvieraserious  --          --
=end