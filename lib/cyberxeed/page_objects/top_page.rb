require 'page-object'

module CyberXeed
  module PageObjects
    class TopPage
      include PageObject

      in_frame(id: 'FRAME1') do |frame|
        div(:closing_time_process_menu, id: 'menu01', frame: frame)
        img(:logout, name: 'LOGGIF')
      end
      in_frame(:name => 'FRAME2') do |frame|
        link(:working_data_input_menu, id: 'menu01_03', frame: frame)
        link(:working_weekly_report_menu, id: 'menu01_10', frame: frame)
      end

      def page_to_working_weekly_report
        puts "TOP Page Start"
        sleep 1
        closing_time_process_menu_element.click
        puts "終業日時処理 を クリック"
        sleep 1
        working_weekly_report_menu
        puts "終業週報 を クリック"
        sleep 3
        WorkingWeeklyReportPage.new(browser)
      end

    end
  end
end
