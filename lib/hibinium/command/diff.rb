require 'hibinium'
require 'hibinium/command'
require 'hibinium/scenario'

module Hibinium
  class Command < Thor
    desc 'diff', 'compare your enter daily report and cx'

    def diff(year = "", month = "")
      # 日々報の指定の月のデータを取得
      specified_month       = month.to_s.empty? ? Date.today : Date.new(year.to_i, month.to_i, -1)
      start_date            = Date.new(specified_month.year, specified_month.month, 1)
      end_date              = specified_month
      hibifo_monthly_report = get_hibifo_monthly_report(start_date, end_date)

      # Cyberxeedの指定の月のデータを取得
      cyberxeed_monthly_report = Hibinium::Scenario.get_monthly_work_record_table(year, month)

      # 比較
      total_judge = true
      (start_date..end_date).each do |day|
        date             = day.strftime("%m/%d")
        hibifo_report    = hibifo_monthly_report.find do |row|
          row['日付'] == date
        end
        cyberxeed_report = cyberxeed_monthly_report.find do |row|
          row['日付'] == date
        end

        h_start  = hibifo_report['出勤時刻']
        h_end    = hibifo_report['退勤時刻']
        c_start  = cyberxeed_report['出勤時刻'].gsub(' ', '0')
        c_end    = cyberxeed_report['退勤時刻'].gsub(' ', '0')
        off_days = %w[法外 法定]
        if h_start == c_start && h_end == c_end
          judge = "OK"
        else
          calend = cyberxeed_report['ｶﾚﾝﾀﾞ']
          if off_days.include?(calend) && c_start == '00000' && c_end == '00000'
            judge = "休"
          else
            judge       = "NG"
            total_judge = false
          end
        end
        puts "#{date} | #{judge} | #{h_start} - #{h_end} | #{c_start} - #{c_end}"
      end

      if total_judge
        puts "差異はありませんでした。"
      else
        puts "差異があります！"
      end

    end

    private

    def get_hibifo_monthly_report(start_date, end_date)
      # 日々報にログイン
      browser = chrome_hibifo
      begin
        hibifo_page = Hibinium::Scenario.login_with(browser)

        day_of_the_week = %w[日 月 火 水 木 金 土]
        puts "for #{start_date.to_s} ~ #{end_date.to_s}"
        array = []
        (start_date..end_date).each do |day|
          puts "get hibi.i3-systems.com/report/#{day.strftime("%Y-%m-%d")}"
          hibifo_page.page_to_specified_date(day.strftime("%Y-%m-%d"))
          hash         = {}
          hash['日付']   = day.strftime("%m/%d")
          hash['曜']    = day_of_the_week[day.wday]
          hash['出勤時刻'] = hibifo_page.start_time
          hash['退勤時刻'] = hibifo_page.end_time
          array << hash
        end
        array
      rescue
        browser.close
      end
    end

  end
end