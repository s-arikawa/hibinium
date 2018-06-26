require 'rspec'
require 'hibinium/page_objects/login_page'
require 'hibinium/page_objects/hibifo_page'

RSpec.describe Hibinium::PageObjects::LoginPage do

  let(:browser) {
    Selenium::WebDriver::Chrome.driver_path = "lib/chromedriver"
    driver = Selenium::WebDriver.for :chrome # ブラウザ起動
    driver.get 'https://hibi.i3-systems.com/'
    driver
  }

  it 'login' do
    login_page = Hibinium::PageObjects::LoginPage.new(browser)
    hibifo_page = login_page.login_with("arikawa", "printf192")

    puts "日付 :" + hibifo_page.date
    puts "開始時刻 :" + hibifo_page.start_time
    puts "終了時刻 :" + hibifo_page.end_time
  end
end