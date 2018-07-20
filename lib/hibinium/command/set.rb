require 'hibinium'
require 'hibinium/command'
require 'hibinium/command/model/hibifo_template'
require 'hibinium/command/model/hibifo_config'
require 'hibinium/page_objects'
require 'hibinium/page_objects/login_page'
require 'hibinium/page_objects/hibifo_page'
require 'hibinium/page_objects/report_edit_rows'
require 'hibinium/page_objects/report_edit_row'
require 'cyberxeed/page_objects/login_page'
require 'cyberxeed/page_objects/top_page'
require 'cyberxeed/page_objects/working_weekly_report_page'
require 'yaml'
require 'date'

module Hibinium
  class Command < Thor
    desc 'set', 'hibifo set Template by day of the week and temporary save.'

    def set(date = "")
      puts "Hibifo set Template Start!! #{date}"

      # 設定する日の曜日を取得
      day_of_the_week = %w[sunday monday tuesday wednesday thursday friday saturday]
      specified_date = date.empty? ? Date.today : Date.new(date)
      puts "specified date : #{specified_date} #{specified_date.wday} #{day_of_the_week[specified_date.wday]}"

      # 曜日テンプレートをload
      template = HibifoTemplate.new.load.to_hash[day_of_the_week[specified_date.wday]]
      puts "template config file loaded!"

      # user/pass設定ファイルをload
      user_config = HibifoConfig.new.load.hibifo
      puts "user config file loaded!"

      # 日々報にログイン
      browser = chrome_hibifo
      puts "open chrome browser"
      login_page = Hibinium::PageObjects::LoginPage.new(browser)
      puts "got hibifo url"
      hibifo_page = login_page.login_with(user_config.user_name, user_config.password)
      puts "hibifo login success!"

      # 指定の日に移動(指定なしの場合は不要)
      hibifo_page.page_to_specified_date(specified_date.strftime("%Y-%m-%d")) unless date.empty?
      puts "move to hibifo page"

      # 入力済みでないか確認
      #   入力済みだったら終わる
      hibifo_page.report_edit_rows.each do |row|
        if row.entered?
          puts "warn: hibifo #{specified_date} is entered!!! stop input"
          return
        end
      end

      # 出社打刻時間をCyberxeedから取得
      checkin_time = get_checkin_time(specified_date)
      # 出社打刻に打刻時刻をセット
      hibifo_page.start_time = checkin_time
      puts "勤務時間の開始時刻に#{checkin_time}を設定"

      # テンプレートを入力
      template.each_with_index do |job, i|
        row = hibifo_page.report_edit_rows[i]
        row.job_code = job["code"]
        row.job_text = job["text"]
        row.job_time = job["time"]
        puts "input row[#{i}] : #{job["code"]} | #{job["text"]} | #{job["time"]}"
      end

      # 一時保存
      hibifo_page.temporary_save
      puts "hibifo #{specified_date} saved temporary"
    end

    private

    def chrome_hibifo
      options = Selenium::WebDriver::Chrome::Options.new
      options.add_argument('--headless')
      driver = Selenium::WebDriver.for :chrome, options: options # ブラウザ起動
      driver.get Hibifo_URL
      driver
    end

    def firefox_cyberxeed
      options = Selenium::WebDriver::Firefox::Options.new
      options.add_argument('--headless')
      driver = Selenium::WebDriver.for :firefox, options: options # ブラウザ起動
      driver.get CyberXeed_URL
      driver
    end

    def get_checkin_time(specified_date)
      user_config = HibifoConfig.new.load.cyberxeed
      browser = firefox_cyberxeed
      puts "oprn firefox browser"
      login_page = CyberXeed::PageObjects::LoginPage.new(browser)
      puts "got cyberxeed url"
      top_page = login_page.login_with(user_config.company_code, user_config.user_name, user_config.password)
      puts "cyberxeed login success!"
      wwr_page = top_page.page_to_working_weekly_report
      puts "move to working_weekly_report page"

      # 指定の日を検索する
      wwr_page.period_end = specified_date.to_s.gsub('-', '')
      wwr_page.search
      sleep 5
      result_table = wwr_page.result_table_hash

      puts result_table

      date = specified_date.strftime("%m/%d")
      target_row = result_table.find do |row|
        row['日付'] == date
      end

      p target_row

      return target_row['出勤時刻']

    end

  end
end