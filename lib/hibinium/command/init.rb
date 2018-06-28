require 'hibinium'
require 'hibinium/command'
require 'yaml'
require 'highline'

module Hibinium
  class Command < Thor
    desc 'init', 'hibinium configuration file make up!'

    def init
      if File.exist?(Hibinium::TemplateFile)
        return if HighLine.agree("The file 'hibinium.yml' already exists. Do you want to overwrite? [Y/n]")
      end
      File.write(Hibinium::TemplateFile, generate_template_yaml)
      puts "make file #{Hibinium::TemplateFile}"
    end

    private

    def generate_template_yaml
      hash = {}
      hash[:hibifo] = {
          user_name: nil,
          password: nil
      }
      hash[:cyberxeed] = {
          company_code: "i3-systems",
          user_name: nil,
          password: nil
      }
      YAML.dump(hash)
    end
  end
end