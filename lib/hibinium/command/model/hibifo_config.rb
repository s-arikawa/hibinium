require 'hibinium'

module Hibinium
  # 日々報にログインするための設定を持つ
  class HibifoConfig
    attr_accessor :hibifo, :cyberxeed

    def initialize
      self.hibifo = {user_name: "your_name", password: "*****"}
      self.cyberxeed = {company_code: "i3-systems", user_name: "your_employee_no", password: "*****"}
    end

    def self.default_set
      me = HibifoConfig.new
      # me.hibifo = {user_name: "your_name", password: "*****"}
      # me.cyberxeed = {company_code: "i3-systems", user_name: "your_employee_no", password: "*****"}
      me
    end

    def to_hash
      hash = {}
      instance_variables.each {|var| hash[var.to_s.delete("@")] = instance_variable_get(var)}
      hash
    end

    # ローカル設定ファイルを読み込む
    def load
      yaml = YAML.load_file(ConfigFilePath)
      self.hibifo = yaml["hibifo"]
      self.cyberxeed = yaml["cyberxeed"]
      self
    end
  end
end