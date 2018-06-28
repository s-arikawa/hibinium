require 'rspec'
require 'cyberxeed/page_objects/login_page'
require 'cyberxeed/page_objects/top_page'
require 'cyberxeed/page_objects/working_weekly_report_page'

RSpec.describe CyberXeed::PageObjects::WorkingWeeklyReportPage do

  let(:browser) {
    Selenium::WebDriver::Firefox.driver_path = "lib/geckodriver"
    driver = Selenium::WebDriver.for :firefox # ブラウザ起動
    driver.get 'https://cxg5.i-abs.co.jp/cyberx/login.asp'
    driver
  }

  it 'table each data' do
    login_page = CyberXeed::PageObjects::LoginPage.new(browser)
    top_page = login_page.login_with("i3-systems", "192" , "printf192")
    wwr_page = top_page.page_to_working_weekly_report

    p wwr_page.period_start
    p wwr_page.period_end
    p wwr_page.result_table
    wwr_page.result_table_element.each do |row|
      p row
    end

    p wwr_page.result_table_hash
  end
end