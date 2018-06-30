require 'page-object'

module CyberXeed
  module PageObjects
    class WorkingWeeklyReportPage
      include PageObject

      in_frame(:name => 'FRAME2') do |frame|

        in_iframe({id: 'frames0'}, frame) do |inner_frame|
          text_field(:period_start, id: 'txtYmdStart', frame: inner_frame)
          text_field(:period_end, id: 'txtYmdEnd', frame: inner_frame)

          button(:search, id: 'cmdKensaku', frame: inner_frame)

          table(:result_table, :class => 'ap_table', index: 1, frame: inner_frame)
        end
      end

      # result_tableの内容をArray[hash]で返す。
      def result_table_hash(headers = %w"日付 曜 出勤時刻 退勤時刻")
        array = []
        result_table_element.each do |row|
          hash = {}
          headers.each do |header|
            hash[header] = row[header].text
          end
          array << hash
        end
        array
      end

    end
  end
end