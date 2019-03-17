require 'hibinium'
require 'thor'
require 'hibinium/command/hello'
require 'hibinium/command/init'
require 'hibinium/command/set'
require 'hibinium/command/diff'
require 'hibinium/command/pf'
require 'hibinium/command/rm'

module Hibinium
  class Command < Thor

    no_commands do
      # コマンドオプション -s の ON/OFFを取得する。
      def show_flag
        show = options[:show]
        if show
          false # headless off
        else
          true # headless on
        end
      end

      def date_parse(date = "")
        begin
          week = %w[sunday monday tuesday wednesday thursday friday saturday]
          date = date.empty? ? Date.today : Date.parse(date)
          puts Formatter.option "specified date : #{date} #{week[date.wday]}"
          date
        rescue ArgumentError => err
          puts "指定した日付のフォーマットがおかしいです。(例: 2019-03-17): #{date}"
          raise CopedError.new(err.message)
        end
      end

    end
  end
end
