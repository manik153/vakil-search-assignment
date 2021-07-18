require 'json'

def sudoku_validator(solution)
  benchmark = (1..9).to_a
  begin
    # Each sorted row must be equal to benchmark array
    rows_check = solution.map(&:sort).uniq == [benchmark]
    return false unless rows_check
    # Each sorted column must be equal to benchmark array
    columns_check = solution.transpose.map(&:sort).uniq == [benchmark]
    return false unless columns_check
    for rows in (0..8).each_slice(3)
      for columns in (0..8).each_slice(3)
        box_values = rows.map{ |r| columns.map{ |c| solution[r][c] } }.flatten
        # Each sorted box values must be equal to benchmark array
        box_check = box_values.sort.uniq == benchmark
        return false unless box_check
      end
    end
    # All checks satisfied benchmark
    true
  rescue => error
    "Invalid solution"
  end
end

puts "Enter solution:"
solution = JSON.parse(gets).to_a rescue (puts "Invalid solution"; return [])
puts "Output:"
p sudoku_validator(solution)