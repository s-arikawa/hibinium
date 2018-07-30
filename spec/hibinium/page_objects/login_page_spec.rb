require 'rspec'
require 'hibinium/my_logger'
require 'hibinium/page_objects/login_page'
require 'hibinium/page_objects/hibifo_page'
require 'yaml'
require 'test_constants'

RSpec.describe Hibinium::PageObjects::LoginPage do
  include Hibinium::MyLogger
  let(:browser) {
    TestConstants.chrome_hibifo
  }

  let(:user) {
    TestConstants.hibifo
  }

  after do
    browser.close
  end

  it 'login' do
    login_page  = Hibinium::PageObjects::LoginPage.new(browser)
    hibifo_page = login_page.login_with(user[:user_name], user[:password])

    log.info("日付 :" + hibifo_page.date)
    log.info("開始時刻 :" + hibifo_page.start_time)
    log.info("終了時刻 :" + hibifo_page.end_time)
  end
end