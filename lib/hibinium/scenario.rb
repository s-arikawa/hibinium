require 'utils/formatter'
module Hibinium
  class Scenario
    include Hibinium::BrowserBase

    # Cyberxeedにログインして、勤怠集計ページに移動する
    def self.login_and_move_to_wwr (browser)
      user_config = HibifoConfig.new.load.cyberxeed

      puts "open firefox browser"
      login_page = CyberXeed::PageObjects::LoginPage.new(browser)
      puts "got cyberxeed url"
      top_page = login_page.login_with(user_config.company_code, user_config.user_name, user_config.password)
      puts "cyberxeed login success!"
      wwr_page = top_page.page_to_working_weekly_report
      puts "move to working_weekly_report page"
      wwr_page
    end

    # 日々報にログインする
    def self.login_with(browser)
      user_config = HibifoConfig.new.load.hibifo
      puts "open chrome browser"
      login_page = Hibinium::PageObjects::LoginPage.new(browser)
      puts "got hibifo url"
      hibifo_page = login_page.login_with(user_config.user_name, user_config.password)
      puts Formatter.success "hibifo login success!", label: :SUCCESS
      hibifo_page
    end

    # CyberXeedから就業週報（勤務実績表）を取得する
    # @param start_date
    # @param end_date
    def self.get_work_record_table(start_date, end_date)
      browser = Hibinium::BrowserBase.firefox_cyberxeed
      begin
        wwr_page = Hibinium::Scenario.login_and_move_to_wwr(browser)

        # 指定の日を検索する
        start_date            = start_date.to_s.gsub('-', '')
        end_date              = end_date.to_s.gsub('-', '')
        wwr_page.period_start = start_date
        wwr_page.period_end   = end_date
        puts "#{start_date} ~ #{end_date}の期間で検索"
        wwr_page.search
        sleep 5 # TODO 高速化
        wwr_page.result_table_hash
      rescue
        browser.close
      end
    end

    # CyberXeedから指定された年/月の勤務実績表を取得 (指定がない場合、当月を取得)就業週報（勤務実績表）の1ヶ月分を取得する。
    # @param year
    # @param month
    def self.get_monthly_work_record_table(year = "", month = "")
      # 指定された月の月末日を取得 (指定がない場合、当月を取得)
      specified_month = month.to_s.empty? ? Date.new(Date.today.year, Date.today.month, -1) : Date.new(year.to_i, month.to_i, -1)

      start_date = Date.new(specified_month.year, specified_month.month, 1)
      end_date   = specified_month

      get_work_record_table(start_date, end_date)
    end

  end
end