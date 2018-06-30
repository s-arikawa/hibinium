require 'page-object'

module CyberXeed
  module PageObjects
    class LoginPage
      include PageObject

      page_url("https://cxg5.i-abs.co.jp/cyberx/login.asp")

      text_field(:company_code, name: 'DataSource')
      text_field(:employee_code, name: 'LoginID')
      text_field(:password, name: 'PassWord')
      image(:login, name: 'LOGINBUTTON')

      def login
        login_element.click
      end

      def login_with(company_code, employee_code, password)
        self.company_code = company_code
        self.employee_code = employee_code
        self.password = password
        login
        TopPage.new(@browser)
      end
    end
  end
end
