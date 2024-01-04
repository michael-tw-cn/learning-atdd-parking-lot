$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '../../lib'))

require 'rubygems'
gem 'rspec-expectations'
require 'selenium-webdriver'
require 'rspec/expectations'
require 'park_calc_page'

#before all

# Specify the browser you want to use (in this case, Chrome)
selenium_driver = Selenium::WebDriver.for :chrome

# Navigate to a website
selenium_driver.get('https://www.shino.de/parkcalc')

$park_calc = ParkCalcPage.new(selenium_driver)

# after all
at_exit do
  selenium_driver.quit
end