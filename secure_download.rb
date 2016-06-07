#secure_download.rb

require 'selenium-webdriver'
require 'rspec/expectations'
require 'rest-client'
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

def content_type(file)
  file = File.basename(file)
  if file.include? '.jpg'
    'image/jpeg'
  elsif file.include? '.pdf'
    'application/pdf'
  else
    raise 'Unknown file type'
  end
end

run do
  @driver.get 'http://admin:admin@the-internet.herokuapp.com/download_secure'
  cookie = @driver.manage.cookie_named 'rack.session'
  links = @driver.find_element(css: '.example a')
  links.map! { |link| link.attribute('href') }
  links.each do |link|
    response = RestClient.head link, cookie: { cookie[:name] => cookie[:value] }
    expect(response.headers[:content_type]).to eql(content_type(link)) #this part fails. doesn't get image/jpeg
    expect(response.headers[:content_length].to_i).to be > 0
  end
end
