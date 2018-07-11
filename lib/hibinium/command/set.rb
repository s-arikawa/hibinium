require 'hibinium'
require 'hibinium/command'
require 'hibinium/page_objects'
require 'hibinium/page_objects/login_page'
require 'hibinium/page_objects/hibifo_page'
require 'hibinium/page_objects/report_edit_rows'
require 'hibinium/page_objects/report_edit_row'
require 'yaml'
require 'date'

module Hibinium
  class Command < Thor
    desc 'set', 'hibifo set Template by day of the week and temporary save.'

    def set(date = "")
      puts "Hibifo set Template Start!! #{date}"

      # 設定する日の曜日を取得
      day_of_the_week = %i[sunday monday tuesday wednesday thursday friday saturday]
      specified_date = date.empty? ? Date.today : Date.new(date)
      puts "specified date : #{specified_date} #{specified_date.wday} #{day_of_the_week[specified_date.wday]}"

      # 曜日テンプレートをload
      template = YAML.load_file('hibifo_template.yaml')[day_of_the_week[specified_date.wday]]
      puts "template config file loaded!"
      p template

      # user/pass設定ファイルをload
      user_config = YAML.load_file('hibinium.local.yaml')[:hibifo]
      puts "user config file loaded!"

      # 日々報にログイン
      browser = chrome_hibifo
      puts "open chrome browser"
      login_page = Hibinium::PageObjects::LoginPage.new(browser)
      puts "got hibifo url"
      hibifo_page = login_page.login_with(user_config[:user_name], user_config[:password])
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

      # テンプレートを入力
      template.each_with_index do |job, i|
        row = hibifo_page.report_edit_rows[i]
        row.job_code = job[:code]
        row.job_text = job[:text]
        row.job_time = job[:time]
        puts "input row[#{i}] : #{job[:code]} | #{job[:text]} | #{job[:time]}"
      end

      # 一時保存
      hibifo_page.temporary_save
      puts "hibifo #{specified_date} saved temporary"
    end

    private

    def chrome_hibifo
      Selenium::WebDriver::Chrome.driver_path = "lib/chromedriver"
      options = Selenium::WebDriver::Chrome::Options.new
      options.add_argument('--headless')
      driver = Selenium::WebDriver.for :chrome, options: options # ブラウザ起動
      driver.get Hibinium::PageObjects::Hibifo_URL
      driver
    end

  end
end