require 'hibinium'
require 'hibinium/command'
require 'hibinium/browser_base'
require 'hibinium/scenario'
require 'hibinium/page_objects'
require 'hibinium/page_objects/login_page'
require 'hibinium/page_objects/hibifo_page'
require 'date'
require 'utils/formatter'
require 'awesome_print'

module Hibinium
  class Command < Thor
    desc 'rm', 'hibifo remove day'
    method_option :show, aliases: 's', desc: 'Browser showing'

    def rm(date = "")
      begin
        puts Formatter.headline("Hibifo Remove Start!! #{date}", color: :red)

        specified_date = date_parse(date)

        # 日々報にログイン
        browser = chrome_hibifo(show_flag) #show = true の場合は HeadLessではなくする
        begin
          hibifo_page = Hibinium::Scenario.login_with(browser)

          # 指定の日に移動(指定なしの場合は不要)
          hibifo_page.page_to_specified_date(specified_date.strftime("%Y-%m-%d")) unless date.empty?
          puts Formatter.success("move to hibifo page", label: :SUCCESS)

          # 入力済み確認
          #   未入力だったら終わる
          unless hibifo_page.report_edit_rows.any?(&:entered?)
            puts Formatter.warning("hibifo #{specified_date} is NOT entered!!! stop remove", label: :WARN)
            return
          end

          # 削除する
          hibifo_page.delete

          puts Formatter.success("hibifo #{specified_date} Removed.", label: :SUCCESS)
        ensure
          browser.close if browser
        end

      rescue CopedError
        # 対処済みエラー
      end
    end
  end
end