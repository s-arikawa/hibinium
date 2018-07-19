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
      hibifo_conf = yaml["hibifo"]
      self.hibifo = UserConfig.new(hibifo_conf[:user_name], hibifo_conf[:password])
      cyber_conf = yaml["cyberxeed"]
      self.cyberxeed = UserConfig.new(cyber_conf[:user_name], cyber_conf[:password], cyber_conf[:company_code])
      self
    end
  end

  class UserConfig
    attr_accessor :user_name, :password, :company_code
    def initialize(user_name = "your_name", password = "*****", company_code = "i3-systems")
      self.user_name = user_name
      self.password = password
      self.company_code = company_code
    end
  end
end