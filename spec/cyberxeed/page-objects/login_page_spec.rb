require 'rspec'
require 'cyberxeed/page_objects/login_page'

RSpec.describe CyberXeed::PageObjects::LoginPage do

  let(:browser) {
    Selenium::WebDriver::Firefox.driver_path = "lib/geckodriver"
    driver = Selenium::WebDriver.for :firefox # ブラウザ起動
    driver.get 'https://cxg5.i-abs.co.jp/cyberx/login.asp'
    driver
  }

  it 'login' do
    login_page = CyberXeed::PageObjects::LoginPage.new(browser)
    login_page.login_with("i3-systems", "192" , "printf192")
    sleep 5
    # puts "日付 :" + hibifo_page.date
    # puts "開始時刻 :" + hibifo_page.start_time
    # puts "終了時刻 :" + hibifo_page.end_time
  end
end