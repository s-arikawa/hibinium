require 'hibinium'
require 'hibinium/command'
require 'yaml'

module Hibinium
  class Command < Thor
    desc 'set', 'hibiho set Template by day of the week and temporary save.'

    def set(date = "") #TODO default当日
      # 設定する日の曜日を取得
      day_of_the_week = 'mon'

      # 曜日テンプレートをload
      path = ''
      template = YAML.load(path)

      # 日々報にログイン

      # 指定の日に移動

      # 入力済みでないか確認
      #   入力済みだったら終わる

      # テンプレートを入力

      # 一時保存

    end
  end
end