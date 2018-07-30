require 'hibinium/my_logger'
module Hibinium
  class Scenario
    # Cyberxeedにログインして、勤怠集計ページに移動する
    def self.login_and_move_to_wwr (browser)
      user_config = HibifoConfig.new.load.cyberxeed

      log.info("open firefox browser")
      login_page = CyberXeed::PageObjects::LoginPage.new(browser)
      log.info("got cyberxeed url")
      top_page = login_page.login_with(user_config.company_code, user_config.user_name, user_config.password)
      log.info("cyberxeed login success!")
      wwr_page = top_page.page_to_working_weekly_report
      log.info("move to working_weekly_report page")
      wwr_page
    end

    # 日々報にログインする
    def self.login_with(browser)
      user_config = HibifoConfig.new.load.hibifo
      log.info("open chrome browser")
      login_page = Hibinium::PageObjects::LoginPage.new(browser)
      log.info("got hibifo url")
      hibifo_page = login_page.login_with(user_config.user_name, user_config.password)
      log.info("hibifo login success!")
      hibifo_page
    end

    private
    def self.log
      MyLogger.logger
    end
  end
end