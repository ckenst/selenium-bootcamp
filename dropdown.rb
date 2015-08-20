#filename: dropdown.rb

require 'selenium-webdriver'
require 'rspec/expectations'
include RSpec::Matchers

def setup
  @driver = Selenium::WebDriver.for :firefox
end

def teardown
  @driver.quit
end

def run
  setup
  yield
  teardown
end

run do
  @driver.get 'http://the-internet.herokuapp.com/dropdown'

  dropdown_list = @driver.find_element(id: 'dropdown')
  options = dropdown_list.find_elements(tag_name: 'option')
  options.each { |option| option.click if option.text == 'Option 2' }

  selected_option = options.map { |option| option.text if option.selected? }.join
  expect(selected_option).to eql 'Option 2'
end
