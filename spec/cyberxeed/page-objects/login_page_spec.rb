require 'rspec'
require 'cyberxeed/page_objects/login_page'
require 'cyberxeed/page_objects/top_page'
require 'test_constants'

RSpec.describe CyberXeed::PageObjects::LoginPage do

  let(:browser) {
    TestConstants.firefox_cyberxeed
  }

  let(:user) {
    TestConstants.cyberxeed
  }

  after do
    browser.close
  end

  it 'login' do
    login_page = CyberXeed::PageObjects::LoginPage.new(browser)
    login_page.login_with(user[:company_code], user[:user_name], user[:password])
  end
end