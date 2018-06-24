require 'page-object'

module Hibinium
  module PageObjects
    class LoginPage
      include PageObject

      text_field(:username, :id => 'UserUserName')
      text_field(:password, :id => 'UserPassword')
      button(:login, :name => 'login')

    end
  end
end
