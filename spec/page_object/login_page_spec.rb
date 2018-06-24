require 'rspec'
require 'hibinium/page_objects/login_page'

RSpec.describe 'My behaviour' do

  it 'should do something' do

    Selenium::WebDriver::Chrome.driver_path = "lib/chromedriver"
    # options = Selenium::WebDriver::Chrome::Options.new(args: ['start-maximized', 'user-data-dir=/tmp/temp_profile'])
    driver = Selenium::WebDriver.for :chrome # ブラウザ起動
    driver.get 'https://hibi.i3-systems.com/'

    sleep 5

    login_page = Hibinium::PageObjects::LoginPage.new(driver)
    login_page.username = "arikawa"
    login_page.password = "printf192"
    login_page.login

    sleep 5
  end
end