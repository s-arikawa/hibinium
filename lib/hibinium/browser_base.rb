require 'hibinium'

module Hibinium
  module BrowserBase
    def chrome_hibifo(headless = true)
      options = Selenium::WebDriver::Chrome::Options.new
      options.add_argument('--headless') if headless
      options.add_argument("--window-size=1280,1000") # タスクをたくさん登録するとウィンドウから一時保存ボタンがはみ出す
      driver = Selenium::WebDriver.for :chrome, options: options # ブラウザ起動
      driver.get Hibifo_URL
      driver
    end

    def firefox_cyberxeed(headless = true)
      options = Selenium::WebDriver::Firefox::Options.new
      options.add_argument('--headless') if headless
      driver = Selenium::WebDriver.for :firefox, options: options # ブラウザ起動
      driver.get CyberXeed_URL
      driver
    end

    def self.firefox_cyberxeed
      options = Selenium::WebDriver::Firefox::Options.new
      options.add_argument('--headless')
      driver = Selenium::WebDriver.for :firefox, options: options # ブラウザ起動
      driver.get CyberXeed_URL
      driver
    end
  end
end