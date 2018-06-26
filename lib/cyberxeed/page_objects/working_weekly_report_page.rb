require 'page-object'

module CyberXeed
  module PageObjects
    class WorkingWeeklyReportPage
      include PageObject

      in_frame(:name => 'FRAME2') do |frame|
        text_field(:period_start, :id => 'txtYmdStart', :frame => frame)
        text_field(:period_end, :id => 'txtYmdEnd', :frame => frame)

        button(:serch, :id => 'cmdKensaku', :frame => frame)

        table(:result_table, :id => 'ap_table', :frame => frame)
      end
    end
  end
end