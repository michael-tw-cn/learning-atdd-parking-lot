require 'selenium-webdriver'

class ParkCalcPage
  attr :page

  @@lot_identifier = 'ParkingLot'
  @@starting_prefix = 'Starting'
  @@leaving_prefix = 'Leaving'
  @@am_or_pm_radio_button_template = "//input[@name='%sTimeAMPM' and @value ='%s']"
  @@date_template = '%sDate'
  @@time_template = '%sTime'
  @@xpath_costs = "//tr[td/div[@class='SubHead']='estimated Parking costs']/td/span/b"

  @@duration_map = {
  '30 minutes' => ['05/04/2010', '00:00', 'AM', '05/04/2010', '00:30', 'AM'],
  '3 hours' => ['05/04/2010', '00:00', 'AM', '05/04/2010', '03:00', 'AM'],
  '5 hours' => ['05/04/2010', '00:00', 'AM', '05/04/2010', '05:00', 'AM'],
  '5 hours 1 minute' => ['05/04/2010', '00:00', 'AM', '05/04/2010', '05:01', 'AM'],
  '12 hours' => ['05/04/2010', '00:00', 'AM', '05/04/2010', '12:00', 'PM'],
  '24 hours' => ['05/04/2010', '00:00', 'AM', '05/05/2010', '00:00', 'AM'],
  '1 day 1 minute' => ['05/04/2010', '00:00', 'AM', '05/05/2010', '00:01', 'AM'],
  '3 days' => ['05/04/2010', '00:00', 'AM', '05/07/2010', '00:00', 'AM'],
  '1 week' => ['05/04/2010', '00:00', 'AM', '05/11/2010', '00:00', 'AM']
  }

  def initialize(page_handle)
    @page = page_handle
  end

  def select(parking_lot)
    dropdown = @page.find_element(name: @@lot_identifier)
    select = Selenium::WebDriver::Support::Select.new(dropdown)
    select.select_by(:text, parking_lot)
  end

  def enter_parking_duration(duration)
    starting_date, starting_time, starting_time_am_pm, leaving_date, leaving_time, leaving_time_am_pm = @@duration_map[duration]
    fill_in_date_and_time_for(@@starting_prefix, starting_date, starting_time, starting_time_am_pm)
    fill_in_date_and_time_for(@@leaving_prefix, leaving_date, leaving_time, leaving_time_am_pm)
  end

  def parking_costs
    submit_element = @page.find_element(name: 'Submit')
    submit_element.click
    wait = Selenium::WebDriver::Wait.new(timeout: 10)
    wait.until { @page.find_element(:xpath, @@xpath_costs).displayed? }
    costs_element = @page.find_element(:xpath, @@xpath_costs)
    costs_element.text
  end

  private

  def fill_in_date_and_time_for(form_prefix, date, time, am_or_pm)
    starting_date_input_field = @page.find_element(name: @@date_template % form_prefix)
    starting_date_input_field.clear
    starting_date_input_field.send_keys(date)
    starting_time_input_field = @page.find_element(name: @@time_template % form_prefix)
    starting_time_input_field.clear
    starting_time_input_field.send_keys(time)
    starting_time_am_pm_element = @page.find_element(:xpath, @@am_or_pm_radio_button_template % [form_prefix, am_or_pm])
    starting_time_am_pm_element.click
  end

end