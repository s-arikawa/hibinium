require 'selenium-webdriver'

RSpec.describe Hibinium do
  it "has a version number" do
    expect(Hibinium::VERSION).not_to be nil
  end

  it "does something useful" do
    Selenium::WebDriver::Chrome.driver_path = "lib/chromedriver"
    # options = Selenium::WebDriver::Chrome::Options.new(args: ['start-maximized', 'user-data-dir=/tmp/temp_profile'])
    driver = Selenium::WebDriver.for :chrome # ブラウザ起動
    driver.get 'https://hibi.i3-systems.com/'
    sleep 5
    driver.quit
  end
end
