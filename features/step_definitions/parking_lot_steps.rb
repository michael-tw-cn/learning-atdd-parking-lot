When(/^I park my car in the Valet Parking Lot for (.*)$/) do |duration|
  $park_calc.select('Valet Parking')
  $park_calc.enter_parking_duration(duration)
end

Then(/^I will have to pay (.*)$/) do |price|
  expect($park_calc.parking_costs).to eq(price)
end