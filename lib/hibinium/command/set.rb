require 'hibinium'
require 'hibinium/command'
require 'hibinium/browser_base'
require 'hibinium/scenario'
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
require 'utils/formatter'
require 'awesome_print'

module Hibinium
  class Command < Thor
    include Hibinium::BrowserBase
    desc 'set', 'hibifo set Template by day of the week and temporary save.'
    method_option :show, aliases: 's', desc: 'Browser showing'

    def set(date = "", show = false)
      puts Formatter.headline("Hibifo set Template Start!! #{date}", color: :red)

      # 設定する日の曜日を取得
      day_of_the_week = %w[sunday monday tuesday wednesday thursday friday saturday]
      specified_date  = date.empty? ? Date.today : Date.parse(date)
      puts Formatter.option "specified date : #{specified_date} #{specified_date.wday} #{day_of_the_week[specified_date.wday]}"

      # 曜日テンプレートをload
      template = HibifoTemplate.new.load.to_hash[day_of_the_week[specified_date.wday]]
      puts Formatter.success("template config file loaded!", label: :SUCCESS)

      # 日々報にログイン
      browser = chrome_hibifo(show_flag) #show = true の場合は HeadLessではなくする
      begin
        hibifo_page = Hibinium::Scenario.login_with(browser)

        # 指定の日に移動(指定なしの場合は不要)
        hibifo_page.page_to_specified_date(specified_date.strftime("%Y-%m-%d")) unless date.empty?
        puts Formatter.success("move to hibifo page", label: :SUCCESS)

        # 入力済みでないか確認
        #   入力済みだったら終わる
        if hibifo_page.report_edit_rows.any?(&:entered?)
          puts Formatter.warning("hibifo #{specified_date} is entered!!! stop input", label: :WARN)
          return
        end

        # 出勤/退勤打刻時間をCyberxeedから取得
        checkin_out_row = get_checkin_out_row(specified_date)
        unless checkin_out_row['出勤時刻'].rstrip.empty?
          checkin_time = checkin_out_row['出勤時刻'] == '__:__' ? '09:00' : checkin_out_row['出勤時刻']
          # 開始打刻に出勤打刻時刻をセット
          hibifo_page.start_time = checkin_time
          puts Formatter.option("勤務時間の開始時刻に#{checkin_time}を設定")
        end
        unless checkin_out_row['退勤時刻'].rstrip.empty?
          checkout_time = checkin_out_row['退勤時刻'] == '__:__' ? '18:00' : checkin_out_row['退勤時刻']
          # 終了打刻に退勤打刻時刻をセット
          hibifo_page.end_time = checkout_time
          puts Formatter.option("勤務時間の終了時刻に#{checkout_time}を設定")
        end

        # テンプレートが5行以上あったらレコード追加する
        while template.length >= hibifo_page.report_edit_rows.size
          hibifo_page.report_edit_rows.add_row
        end

        # テンプレートを入力
        template.each_with_index do |job, i|
          row          = hibifo_page.report_edit_rows[i]
          row.job_code = job["code"]
          row.job_text = job["text"]
          row.job_time = job["time"]
          puts Formatter.label("input row[#{i}]", "#{job["code"]} | #{job["text"]} | #{job["time"]}", :yellow)
        end

        # 一時保存
        hibifo_page.temporary_save
        puts Formatter.success("hibifo #{specified_date} saved temporary", label: :SUCCESS)

      rescue => e
        browser.save_screenshot('screenshot.png')
        puts Formatter.error('日々報の更新に失敗しました。')
        puts Formatter.error(e.backtrace.join("\n"))
        puts Formatter.error(e.message)
      ensure
        browser.close
      end
    end

    private

    def get_checkin_out_row(specified_date)
      browser = firefox_cyberxeed(show_flag)
      begin
        # 指定の日を検索する
        search_start_day = (specified_date.day - 1) > 0 ? (specified_date.day - 1) : 1
        s_date           = Date.new(specified_date.year, specified_date.month, search_start_day)
        start_date       = s_date.to_s.gsub('-', '')
        end_date         = specified_date.to_s.gsub('-', '')
        result_table     = Hibinium::Scenario.get_work_record_table(browser, start_date, end_date)

        date       = specified_date.strftime("%m/%d")
        target_row = result_table.find do |row|
          row['日付'] == date
        end

        return target_row
      ensure
        browser.close
      end
    end

    def show_flag
      show = options[:show]
      if show
        false # headless off
      else
        true # headless on
      end
    end

  end
end