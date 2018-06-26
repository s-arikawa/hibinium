require 'page-object'

module CyberXeed
  module PageObjects
    class WorkingWeeklyReportPage
      include PageObject

      in_frame(:name => 'FRAME2') do |frame|

        in_iframe({:id => 'frames0'}, frame) do |inner_frame| # in_frame(:id => 'frames0') do |inner_frame|
          text_field(:period_start, :id => 'txtYmdStart', :frame => inner_frame)
          text_field(:period_end, :id => 'txtYmdEnd', :frame => inner_frame)

          button(:search, :id => 'cmdKensaku', :frame => inner_frame)

          table(:result_table, :class => 'ap_table', :index => 1, :frame => inner_frame)
        end
      end

      # def result_table
      #   p period_start
      #   p period_end
      #   p result_table
      #   result_table
      # end
    end
  end
end