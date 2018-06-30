require 'page-object'

module Hibinium
  module PageObjects
    class LoginPage
      include PageObject

      page_url("https://hibi.i3-systems.com/user/login")

      text_field(:username, id: 'UserUserName')
      text_field(:password, id: 'UserPassword')
      button(:login, name: 'login')

      def login_with(username, password)
        self.username = username
        self.password = password
        login
        sleep 2 # ページがjavascriptで初期化されるのを待つ
        HibifoPage.new(@browser)
      end

    end
  end
end
