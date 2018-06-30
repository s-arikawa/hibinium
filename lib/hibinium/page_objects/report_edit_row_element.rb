require 'hibinium/page_objects/report_edit_rows'

module Hibinium
  module PageObjects
    class ReportEditRowElement

      def initialize(browser, index)
        @browser = browser
        @row_index = index
      end

      def job_code_element
        ReportEditRows.elements(@browser)[@row_index].find_element(class: "detailCodeInput")
      end
      def job_code
        self.job_code_element.text
      end
      def job_code=(value)
        self.job_time_element.clear
        self.job_code_element.send_keys(value)
      end

      def job_text_element
        ReportEditRows.elements(@browser)[@row_index].find_element(class: "detailTextInput")
      end
      def job_text
        self.job_text_element.text
      end
      def job_text=(value)
        self.job_time_element.clear
        self.job_text_element.send_keys(value)
      end

      def job_time_element
        ReportEditRows.elements(@browser)[@row_index].find_element(class: "detailTimeInput")
      end
      def job_time
        self.job_time_element.text
      end
      def job_time=(value)
        self.job_time_element.clear
        self.job_time_element.send_keys(value)
      end

    end
  end
end

