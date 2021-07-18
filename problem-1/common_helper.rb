module CommonHelper
  DATABASE = {}

  def set_advocate
    @advocate = DATABASE[@inputs['id']]
  end

  def is_senior?
    @advocate && @advocate['senior_id'].nil?
  end

  def all_cases
    DATABASE.values.map{ |adv_data| adv_data['cases'] }.flatten
  end

  def advocate_exists?(id)
    !(DATABASE[id].nil?)
  end

  def get_senior_id(id)
    DATABASE[id].to_h['senior_id']
  end

  def get_advocate_state(id)
    DATABASE[id].to_h['state']
  end

  def get_cases(id)
    DATABASE[id].to_h['cases']
  end

  def show_advocate_details(id, with_case = false)
    puts "\nDisplay:"
    if DATABASE[id].to_h['senior_id'] # Junior
      display_senior_details(DATABASE[id].to_h['senior_id'], with_case)
      display_junior_details(id)
    else # Senior
      display_senior_details(id, with_case)
      DATABASE.select{ |adv_id, adv_data|
        adv_data['senior_id'].to_s == id.to_s
      }.each do |adv_id, adv_data|
        display_junior_details(adv_id)
      end
    end
  end

  def display_senior_details(senior_id, with_case)
    advocate = DATABASE[senior_id].to_h
    puts "Advocate Name: #{senior_id}"
    puts "Practicing States: #{advocate['state']}" if advocate['state']
    display_cases(senior_id)
  end

  def display_junior_details(id)
    advocate = DATABASE[id].to_h
    puts "-Advocate Name: #{id}"
    puts "-Practicing states: #{advocate['state']}" if advocate['state']
  end

  def display_cases(id)
    cases = DATABASE[id].to_h['cases']
    practising_cases = cases.reject{ |i,c|
      c['is_rejected']
    }.map{ |id,data|
      "#{id}-#{data['state']}"
    }
    rejected_cases = cases.select{ |i,c|
      c['is_rejected']
    }.map{ |id,data|
      "#{id}-#{data['state']}"
    }
    puts "Practicing Cases: #{practising_cases.join(', ')}" unless practising_cases.empty?
    puts "BlockList Cases: #{rejected_cases.join(', ')}" unless rejected_cases.empty?
  end
end