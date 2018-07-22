module Hibinium
  class Scenario

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
      puts "hibifo login success!"
      hibifo_page
    end
  end
end