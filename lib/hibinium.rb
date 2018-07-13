require "hibinium/version"
require 'hibinium/command'

module Hibinium
  ConfigFileDirPath = File.join(Dir.home, ".hibifo")
  TemplateFilePath = File.join("#{ConfigFileDirPath}", "hibinium.template.yaml")
  ConfigFilePath = File.join("#{ConfigFileDirPath}", "/hibinium.local.yaml")
  Hibifo_URL = 'https://hibi.i3-systems.com/'
  CyberXeed_URL = 'https://cxg5.i-abs.co.jp/cyberx/login.asp'
end
