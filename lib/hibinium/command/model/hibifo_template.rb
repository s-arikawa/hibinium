module Hibinium
# 日々報に入力する内容を持つモデル
# 実態は設定ファイル
  class HibifoTemplate
    attr_accessor :sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday

    def initialize
      @sunday = []
      @monday = []
      @tuesday = []
      @wednesday = []
      @thursday = []
      @friday = []
      @saturday = []
    end

    # initで空の設定ファイルを作るときに使用する
    def self.default_set
      me = HibifoTemplate.new
      me.sunday << ReportDetailRow.new
      3.times do
        me.monday << ReportDetailRow.new
        me.tuesday << ReportDetailRow.new
        me.wednesday << ReportDetailRow.new
        me.thursday << ReportDetailRow.new
        me.friday << ReportDetailRow.new
      end
      me.saturday << ReportDetailRow.new
      me
    end

    def to_hash
      hash = {}
      instance_variables.each do |var|
        hash[var.to_s.delete("@")] = instance_variable_get(var).collect {|row| row.to_hash}
      end
      hash
    end
  end

# 日々報の詳細行
  class ReportDetailRow
    attr_accessor :code, :text, :time

    def initialize
      self.code = ""
      self.text = ""
      self.time = "00:00"
    end

    def to_hash
      hash = {}
      instance_variables.each {|var| hash[var.to_s.delete("@")] = instance_variable_get(var)}
      hash
    end
  end

end