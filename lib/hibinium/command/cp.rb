require 'hibinium'
require 'hibinium/command'
require 'hibinium/browser_base'
require 'hibinium/scenario'
require 'hibinium/command/model/hibifo_template'
require 'hibinium/command/error/coped_error'
require 'hibinium/page_objects/hibifo_page'
require 'hibinium/page_objects/report_edit_rows'
require 'hibinium/page_objects/report_edit_row'
require 'cyberxeed/page_objects/working_weekly_report_page'
require 'date'
require 'utils/formatter'
require 'awesome_print'

module Hibinium
  class Command < Thor
    include Hibinium::BrowserBase
    desc 'cp', 'hibifo copy.'
    method_option :show, aliases: 's', desc: 'Browser showing'
    method_option :date, aliases: 'd', type: :string, defalut: nil, desc: '指定した日付のタスクをコピー'
    method_option :week_of_the_day, aliases: 'w', desc: '入力済みの直近の同じ曜日からタスクをコピー'

    # 入力済みのタスクをコピーして指定した日付に保存するコマンド。
    # デフォルトのコピー元は入力されている前日
    # デフォルトのコピー先は当日
    #
    # コマンド引数:
    #   hibi cp yyyy-mm-dd
    #     yyyy-mm-dd : コピー先の日付 (デフォルトは当日)
    # options:
    #   --date(-d): コピー元の日付を指定できる
    #   --week_of_the_day(-w): コピー元の曜日を指定できる
    #
    # 前日のタスクを探すが、直近の前日にタスクが登録されていなかったら、
    # 過去にさかのぼって登録されている日まで見つけに行く。
    #
    def cp(date = "")
      begin
        puts Formatter.headline("Hibifo copy tasks Start!! #{date}", color: :red)

        # 設定する日を取得
        specified_date = date_parse(date)

        # 日々報にログイン
        browser = chrome_hibifo(show_flag)
        begin
          hibifo_page = Hibinium::Scenario.login_with(browser)

          # 指定の日に移動(指定なしの場合は不要)
          hibifo_page.page_to_specified_date(specified_date) unless date.empty?
          puts Formatter.success("move to hibifo page", label: :SUCCESS)

          # 入力済みでないか確認
          #   入力済みだったら終わる
          if hibifo_page.report_edit_rows.any?(&:entered?)
            puts Formatter.warning("hibifo #{specified_date} is entered!!! stop input", label: :WARN)
            return
          end

          # コピー元を探してタスクを取得する
          copy_source_date = option_date || specified_date

          puts Formatter.arrow("Find task to copy", color: :green)
          copy_source_rows = copy_yesterday(copy_source_date, hibifo_page, option_week)
          copy_source_rows.each_with_index do |copied_row, i|
            puts Formatter.label("copied row[#{i}]", "#{copied_row[:code]} | #{copied_row[:text]} | #{copied_row[:time]}", :yellow)
          end
          if copy_source_rows.empty?
            puts Formatter.warning("コピー元を探しましたが、入力済みのタスクがありませんでした。", label: :WARN)
            return
          end

          # コピー先のページに移動する
          puts Formatter.arrow("move to pasting date page", color: :green)
          hibifo_page.page_to_specified_date(specified_date)

          # タスクが5行以上あったらレコード追加する
          while copy_source_rows.length >= hibifo_page.report_edit_rows.size
            hibifo_page.report_edit_rows.add_row
          end

          # タスクを入力
          copy_source_rows.each_with_index do |job, i|
            row          = hibifo_page.report_edit_rows[i]
            row.job_code = job[:code]
            row.job_text = job[:text]
            row.job_time = job[:time]
            puts Formatter.label("input row[#{i}]", "#{job[:code]} | #{job[:text]} | #{job[:time]}", :yellow)
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

      rescue CopedError
        # 対処済みエラー
      end

    end

    private

    # 前日のタスクをコピーする。
    # 前日に登録がない場合は、その前の日にさかのぼって見つかるまで探す。
    # @param [Date] specified_date 指定した日付
    # @param [HibifoPage] hibifo_page 日々報PageObject
    # @param [Boolean] week_on 曜日指定オプション ON/OFF
    # @return [Array] 前日のタスク
    def copy_yesterday(specified_date, hibifo_page, week_on)
      rows = []
      specified_date.prev_day.step(specified_date - 100, -1) do |yesterday|
        if week_on
          # 曜日が同じ日だけ処理対象にする
          next unless compare_week(specified_date, yesterday)
        end
        yesterday_page = hibifo_page.page_to_specified_date(yesterday)
        next unless yesterday_page.entered? # 未入力の日はSKIP
        yesterday_page.report_edit_rows.map do |row|
          next unless row.entered? # 未入力行はSKIP
          hash        = {}
          hash[:code] = row.job_code
          hash[:text] = row.job_text
          hash[:time] = row.job_time
          rows << hash
        end
        break
      end
      rows
    end

    def compare_week(specified_date, yesterday)
      if specified_date.wday == yesterday.wday
        week = %w[sunday monday tuesday wednesday thursday friday saturday]
        puts Formatter.label(nil, "#{yesterday} #{week[yesterday.wday]}", :blue)
        true
      else
        false
      end
    end

    # オプション コピー元日付を取得する。
    def option_date
      date = options[:date]
      # 処理の事情によりオプションで指定した日の次の日付を返す.
      date.nil? ? nil : date_parse(date).next_day
    end

    # オプション 曜日コピー が ON or OFF
    def option_week
      week = options[:week_of_the_day]
      !week.nil?
    end

  end
end