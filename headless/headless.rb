require 'selenium-webdriver'
require 'rspec/expectations'
include RSpec::Matchers

def setup
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--headless')
  options.add_argument('--disable-gpu')
  options.add_argument('--remote-debugin-port=9222')
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
  @driver.get 'http://the-internet.herokuapp.com'
  expect(@driver.title).to eql 'The Internet'
  @driver.save_screenshot(File.join(Dir.pwd, "internet-main-page.png"))
end
