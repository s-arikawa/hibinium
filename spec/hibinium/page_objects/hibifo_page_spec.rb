require 'rspec'
require 'hibinium/page_objects/login_page'
require 'hibinium/page_objects/hibifo_page'
require 'yaml'
require 'test_constants'

RSpec.describe Hibinium::PageObjects::HibifoPage do

  let(:browser) {
    TestConstants.chrome_hibifo
  }

  let(:user) {
    TestConstants.hibifo
  }

  let(:hibifo_page) {
    login_page = Hibinium::PageObjects::LoginPage.new(browser)
    login_page.login_with(user[:user_name], user[:password])
  }

  it 'should temporary_save' do
    puts "日付 :" + hibifo_page.date
    puts "開始時刻 :" + hibifo_page.start_time
    puts "終了時刻 :" + hibifo_page.end_time

    hibifo_page.start_time = "09:25"
    hibifo_page.end_time = "18:25"

    hibifo_page.temporary_save

    puts "日付 :" + hibifo_page.date
    puts "開始時刻 :" + hibifo_page.start_time
    puts "終了時刻 :" + hibifo_page.end_time
  end

  it 'should editing report-edit-rows' do
    hibifo_page.report_edit_rows.each do |row|
      row.job_code = "hoge"
      row.job_text = "moge"
      row.job_time = "01:00"
    end

  end


end