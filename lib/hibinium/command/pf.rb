require 'hibinium'
require 'hibinium/command'
require 'hibinium/scenario'

module Hibinium
  class Command < Thor
    desc 'pf', 'Premium Friday!!'
    method_option :show, aliases: 's', desc: 'Browser showing'

    def pf
      browser = firefox_cyberxeed(show_flag)
      begin
        # 就業週報（勤務実績表）を取得
        monthly_report = Hibinium::Scenario.get_monthly_work_record_table(browser).select { |r| !%w[日付 合計].include?(r['日付']) }

        # 月の所定日数
        off_days             = %w[法外 法定]
        monthly_working_days = monthly_report.count { |row| !off_days.include?(row['ｶﾚﾝﾀﾞ']) }
        # 月の総労働時間（月の所定日数 × 8h）
        monthly_working_hours = monthly_working_days * 8
        # 登録済みの実労働時間
        actual_working_minutes = monthly_report.sum do |row|
          work_time = row['実労働時間'] == "----" ? "00:00" : row['実労働時間']
          hour, min = work_time.split(':').map { |i| i.to_i }
          hour * 60 + min
        end
        # 登録済みの不就労有給時間
        actual_uq_minutes = monthly_report.sum do |row|
          work_time = row['不就労有給'] == "----" ? "00:00" : row['不就労有給']
          hour, min = work_time.split(':').map { |i| i.to_i }
          hour * 60 + min
        end

        # 今月の残り労働予定時間（総労働時間 - 実労働時間 - 不就労有給時間）
        # 今月は残り何分働かないといけないか。
        remaining_working_minutes = monthly_working_hours * 60 - actual_working_minutes - actual_uq_minutes
        # 今月の残り労働予定日数(余りは時間)に換算（残り労働予定時間 % 8h）


        today = Date.today
        # 今月の残り所定日数
        # 今月はあと何日勤務日数があるか
        remaining_working_days = monthly_report.select { |row|
          month, day = row['日付'].split('/')
          date       = Date.new(today.year, month.to_i, day.to_i)
          today <= date # 今日を含んで未来の日
        }.count { |row| !off_days.include?(row['ｶﾚﾝﾀﾞ']) }

        puts "今月は#{monthly_working_days}日(#{monthly_working_hours}h)の所定日数があります。"
        actual_total_minuts = actual_working_minutes + actual_uq_minutes
        puts "今月は#{actual_total_minuts / 60 / 8}日(#{actual_total_minuts / 60}h)分働きました。(内 有給 #{actual_uq_minutes / 60}h)"
        puts "今月の残り所定日数は、今日(#{today.to_s})から数えて#{remaining_working_days}日あるので、"
        if remaining_working_minutes / 60 < remaining_working_days * 8
          puts "休んでいいです(*^_^*) #{remaining_working_days * 8 - remaining_working_minutes / 60}h 残業しています。"
        else
          puts "残業が必要です(´；ω；｀) #{remaining_working_days * 8 - remaining_working_minutes / 60}h 残業が必要です。"
        end

      ensure
        browser.close if browser
      end
    end

    private

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