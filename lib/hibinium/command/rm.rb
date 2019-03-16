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

    def rm(date = "")

      puts Formatter.headline("Hibifo Remove Start!! #{date}", color: :red)

      specified_date = date.empty? ? Date.today : Date.parse(date)
      puts Formatter.option "specified date : #{specified_date}"

      # 日々報にログイン
      browser = chrome_hibifo(false) #show = true の場合は HeadLessではなくする
      begin
        hibifo_page = Hibinium::Scenario.login_with(browser)

        # 指定の日に移動(指定なしの場合は不要)
        hibifo_page.page_to_specified_date(specified_date.strftime("%Y-%m-%d")) unless date.empty?
        puts Formatter.success("move to hibifo page", label: :SUCCESS)

        # 入力済み確認
        #   未入力だったら終わる
        hibifo_page.report_edit_rows.each do |row|
          unless row.entered?
            puts Formatter.warning("hibifo #{specified_date} is NOT entered!!! stop remove", label: :WARN)
            return
          end
        end

        # 削除する
        hibifo_page.delete

        puts Formatter.success("hibifo #{specified_date} Removed.", label: :SUCCESS)

      end
    end
  end
end