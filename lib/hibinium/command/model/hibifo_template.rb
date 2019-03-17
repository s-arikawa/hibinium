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
      yaml.default   = []
      initialize_row = -> (r) { ReportDetailRow.new(r["code"], r["text"], r["time"]) }

      self.sunday    = yaml["sunday"].to_a.map(&initialize_row)
      self.monday    = yaml["monday"].to_a.map(&initialize_row)
      self.tuesday   = yaml["tuesday"].to_a.map(&initialize_row)
      self.wednesday = yaml["wednesday"].to_a.map(&initialize_row)
      self.thursday  = yaml["thursday"].to_a.map(&initialize_row)
      self.friday    = yaml["friday"].to_a.map(&initialize_row)
      self.saturday  = yaml["saturday"].to_a.map(&initialize_row)

      self
    end
  end

  # 日々報の詳細行
  class ReportDetailRow
    attr_accessor :code, :text, :time

    def initialize(code = "", text = "", time = "00:00")
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