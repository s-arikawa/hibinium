require 'yaml'

module TestConstants
  # テスト用のユーザ設定ファイルです。
  # 開発者は自分のUser/Passを設定してください。
  UserConfigYaml = "hibinium.local.yaml"

  def self.cyberxeed
    YAML.load_file(TestConstants::UserConfigYaml)[:cyberxeed]
  end
  def self.hibifo
    YAML.load_file(TestConstants::UserConfigYaml)[:hibifo]
  end

  def self.chrome_hibifo
    Selenium::WebDriver::Chrome.driver_path = "lib/chromedriver"
    driver = Selenium::WebDriver.for :chrome # ブラウザ起動
    driver.get 'https://hibi.i3-systems.com/'
    driver
  end

  def self.firefox_cyberxeed
    Selenium::WebDriver::Firefox.driver_path = "lib/geckodriver"
    driver = Selenium::WebDriver.for :firefox # ブラウザ起動
    driver.get 'https://cxg5.i-abs.co.jp/cyberx/login.asp'
    driver
  end
end