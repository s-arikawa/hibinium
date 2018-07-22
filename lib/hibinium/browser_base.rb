require 'hibinium'

module Hibinium
  module BrowserBase
    def chrome_hibifo
      options = Selenium::WebDriver::Chrome::Options.new
      options.add_argument('--headless')
      driver = Selenium::WebDriver.for :chrome, options: options # ブラウザ起動
      driver.get Hibifo_URL
      driver
    end

    def firefox_cyberxeed
      options = Selenium::WebDriver::Firefox::Options.new
      options.add_argument('--headless')
      driver = Selenium::WebDriver.for :firefox, options: options # ブラウザ起動
      driver.get CyberXeed_URL
      driver
    end
  end
end