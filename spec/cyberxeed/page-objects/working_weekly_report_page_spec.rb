require 'rspec'
require 'cyberxeed/page_objects/login_page'
require 'cyberxeed/page_objects/top_page'
require 'cyberxeed/page_objects/working_weekly_report_page'
require 'test_constants'

RSpec.describe CyberXeed::PageObjects::WorkingWeeklyReportPage do

  let(:browser) {
    TestConstants.firefox_cyberxeed
  }

  let(:user) {
    TestConstants.cyberxeed
  }

  let(:wwr_page) {
    login_page = CyberXeed::PageObjects::LoginPage.new(browser)
    top_page = login_page.login_with(user[:company_code], user[:user_name], user[:password])
    top_page.page_to_working_weekly_report
  }

  after do
    browser.close
  end

  it 'table each data' do
    p wwr_page.period_start
    p wwr_page.period_end
    p wwr_page.result_table
    wwr_page.result_table_element.each do |row|
      p row
    end

    p wwr_page.result_table_hash
  end
end