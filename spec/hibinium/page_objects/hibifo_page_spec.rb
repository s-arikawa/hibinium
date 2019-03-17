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

  after do
    browser.close
  end

  it 'should temporary_save' do
    puts "日付 :" + hibifo_page.date
    puts "開始時刻 :" + hibifo_page.start_time
    puts "終了時刻 :" + hibifo_page.end_time

    hibifo_page.start_time = "09:25"
    hibifo_page.end_time   = "18:25"

    hibifo_page.temporary_save

    puts "日付 :" + hibifo_page.date
    puts "開始時刻 :" + hibifo_page.start_time
    puts "終了時刻 :" + hibifo_page.end_time

    hibifo_page.delete
  end

  it 'should editing report-edit-rows' do
    hibifo_page.report_edit_rows.each do |row|
      row.job_code = "hoge"
      row.job_text = "moge"
      row.job_time = "01:00"
    end
  end

  it 'add new row' do
    hibifo_page.add_detail
    hibifo_page.add_detail

    hibifo_page.report_edit_rows.each do |row|
      row.job_code = "hoge"
      row.job_text = "moge"
      row.job_time = "01:00"
    end

    hibifo_page.report_edit_rows.each do |row|
      puts "code: #{row.job_code} : #{row.job_text} _ #{row.job_time}"
    end
  end

end