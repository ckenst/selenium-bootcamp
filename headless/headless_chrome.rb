require 'selenium-webdriver'
require 'rspec/expectations'
include RSpec::Matchers

def setup
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--headless')
  options.add_argument('--disable-gpu')
  options.add_argument('--remote-debuging-port=9222')
  @driver = Selenium::WebDriver.for :chrome, options: options
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
  @driver.get 'http://www.kenst.com/about'
  expect(@driver.title).to eql "About – Chris Kenst's Blog"
  @driver.save_screenshot("headless.png")
end
