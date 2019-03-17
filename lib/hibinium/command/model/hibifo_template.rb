require 'hibinium'

module Hibinium
# 日々報に入力する内容を持つモデル
# 実態は設定ファイル
  class HibifoTemplate
    attr_accessor :sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday

    DAY_OF_THE_WEEK = %w[sunday monday tuesday wednesday thursday friday saturday]

    def initialize
      @sunday    = []
      @monday    = []
      @tuesday   = []
      @wednesday = []
      @thursday  = []
      @friday    = []
      @saturday  = []
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

    def get(date)
      case date.wday
        when 0
          self.sunday
        when 1
          self.monday
        when 2
          self.tuesday
        when 3
          self.wednesday
        when 4
          self.thursday
        when 5
          self.friday
        when 6
          self.saturday
        else
          raise StandardError
      end
    end

    def to_hash
      hash = {}
      instance_variables.each do |var|
        hash[var.to_s.delete("@")] = instance_variable_get(var).collect { |row| row.to_hash }
      end
      hash
    end

    # ローカル設定ファイルを読み込む
    def load
      yaml           = YAML.load_file(TemplateFilePath)
      self.sunday    = yaml["sunday"].each { |r| ReportDetailRow.new(code: r["code"], text: r["text"], time: r["time"]) } unless yaml["sunday"].nil?
      self.monday    = yaml["monday"].each { |r| ReportDetailRow.new(code: r["code"], text: r["text"], time: r["time"]) } unless yaml["monday"].nil?
      self.tuesday   = yaml["tuesday"].each { |r| ReportDetailRow.new(code: r["code"], text: r["text"], time: r["time"]) } unless yaml["tuesday"].nil?
      self.wednesday = yaml["wednesday"].each { |r| ReportDetailRow.new(code: r["code"], text: r["text"], time: r["time"]) } unless yaml["wednesday"].nil?
      self.thursday  = yaml["thursday"].each { |r| ReportDetailRow.new(code: r["code"], text: r["text"], time: r["time"]) } unless yaml["thursday"].nil?
      self.friday    = yaml["friday"].each { |r| ReportDetailRow.new(code: r["code"], text: r["text"], time: r["time"]) } unless yaml["friday"].nil?
      self.saturday  = yaml["saturday"].each { |r| ReportDetailRow.new(code: r["code"], text: r["text"], time: r["time"]) } unless yaml["saturday"].nil?
      self
    end
  end

  # 日々報の詳細行
  class ReportDetailRow
    attr_accessor :code, :text, :time

    def initialize(code: "", text: "", time: "00:00")
      self.code = code
      self.text = text
      self.time = time
    end

    def to_hash
      hash = {}
      instance_variables.each { |var| hash[var.to_s.delete("@")] = instance_variable_get(var) }
      hash
    end
  end

end