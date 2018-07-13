module Hibinium
  # 日々報にログインするための設定を持つ
  class HibifoConfig
    attr_accessor :hibifo, :cyberxeed

    def initialize
      self.hibifo = {user_name: "your_name", password: "*****"}
      self.cyberxeed = {company_code: "i3-systems", user_name: "your_name", password: "*****"}
    end

    def self.default_set
      me = HibifoConfig.new
      # me.hibifo = {user_name: "your_name", password: "*****"}
      # me.cyberxeed = {company_code: "i3-systems", user_name: "your_name", password: "*****"}
      me
    end

    def to_hash
      hash = {}
      instance_variables.each {|var| hash[var.to_s.delete("@")] = instance_variable_get(var)}
      hash
    end
  end
end