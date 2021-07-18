require './common_helper'
module ProcessHelper
  include CommonHelper

  def process(inputs)
    @inputs = inputs
    set_advocate
    restricted_methods = ['add_junior','add_state_for_advocate','add_case_for_advocate','reject_case']
    return if restricted_methods.include?(inputs['method']) && !(@advocate)
    eval(inputs['method'])
  end

  private
  def add_advocate
    unless @advocate
      DATABASE[@inputs['id']] = {'cases' => {}}
      show_advocate_details(@inputs['id'])
      "Advocate added #{@inputs['id']}."
    end
  end

  def add_junior
    if is_senior? && !(advocate_exists?(@inputs['junior_id']))
      DATABASE[@inputs['junior_id']] = {'senior_id' => @inputs['id'], 'cases' => {}}
      show_advocate_details(@inputs['junior_id'])
      "Advocate added #{@inputs['junior_id']} under #{@inputs['id']}."
    end
  end

  def add_state_for_advocate
    if is_senior? || get_advocate_state(@advocate['senior_id']) == @inputs['state']
      DATABASE[@inputs['id']]['state'] = @inputs['state']
      show_advocate_details(@inputs['id'])
      "State Added #{@inputs['state']} for #{@inputs['id']}."
    else
      show_advocate_details(@inputs['id'])
      "Cannot add #{@inputs['state']} for #{@inputs['id']}."
    end
  end

  def add_case_for_advocate
    if is_senior? || !(get_cases(@advocate['senior_id'])[@inputs['case_id']]['is_rejected'])
      DATABASE[@inputs['id']]['cases'][@inputs['case_id']] = {'state' => @inputs['case_state']}
      show_advocate_details(@inputs['id'], true)
      "Case #{@inputs['case_id']} added for #{@advocate['id']}."
    else
      show_advocate_details(@inputs['id'], true)
      "Cannot add #{@inputs['case_id']} case under #{@advocate['id']}."
    end
  end

  def reject_case
    DATABASE[@inputs['id']]['cases'][@inputs['case_id']] = {'state' => @inputs['case_state'], 'is_rejected' => true}
    show_advocate_details(@inputs['id'], true)
    "Case #{@inputs['case_id']} is added to the Block list for #{@inputs['id']}."
  end

  def get_advocates
    puts "Advocate List:"
    DATABASE.reject{|adv_id,adv_data| adv_data['senior_id']}.keys.map{ |id| show_advocate_details(id) }
  end

  def get_cases_in_state
    case_data = DATABASE.map{ |adv_id,adv_data| 
      [
        adv_id,
        adv_data['cases'].select{ |i,s|
          s['state'] == @inputs['state_id'] && !s['is_rejected'] 
        }.map(&:first).join(', ')
      ]
    }.reject{ |adv_id,adv_data| adv_data.empty? }
    puts "\nDisplay:" 
    puts @inputs['state_id'] 
    puts case_data.map{ |d| d.join(' - ') }.join('\n')
  end
end