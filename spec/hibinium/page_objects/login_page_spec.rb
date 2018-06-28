require 'rspec'
require 'hibinium/page_objects/login_page'
require 'hibinium/page_objects/hibifo_page'
require 'yaml'
require 'test_constants'

RSpec.describe Hibinium::PageObjects::LoginPage do

  let(:browser) {
    TestConstants.chrome_hibifo
  }

  let(:user) {
    TestConstants.hibifo
  }

  it 'login' do
    login_page = Hibinium::PageObjects::LoginPage.new(browser)
    hibifo_page = login_page.login_with(user[:user_name], user[:password])

    puts "日付 :" + hibifo_page.date
    puts "開始時刻 :" + hibifo_page.start_time
    puts "終了時刻 :" + hibifo_page.end_time
  end
end