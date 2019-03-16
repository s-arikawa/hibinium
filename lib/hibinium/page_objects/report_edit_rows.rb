require 'hibinium/page_objects/report_edit_row'

module Hibinium
  module PageObjects

    # 日々報入力ページの詳細入力欄のリストを表すクラス
    class ReportEditRows
      include Enumerable

      def initialize(browser)
        @browser = browser
      end

      def each
        get_elements(@browser).each_with_index do |row, i|
          yield ReportEditRow.new(@browser, i)
        end
      end

      def [](index)
        ReportEditRow.new(@browser, index)
      end

      # 現在の行数を返す
      def size
        get_elements(@browser).size
      end

      # 行を追加
      # 2行追加される。
      def add_row
        HibifoPage.new(@browser).add_detail
      end

      def self.elements(browser)
        new(browser).elements
      end

      def elements
        get_elements(@browser)
      end

      private

      def get_elements(browser)
        browser.find_elements(class: "report-edit-row")
      end

    end
  end
end
