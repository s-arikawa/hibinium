require 'hibinium'
require 'hibinium/command'
require 'hibinium/command/model/hibifo_template'
require 'yaml'
require 'highline'

module Hibinium
  class Command < Thor
    desc 'init', 'hibinium configuration file make up!'

    def init
      make_template = true
      make_config = true

      make_template = HighLine.agree("The file 'hibinium.template.yml' already exists. Do you want to overwrite? [Y/n]") if File.exist?(Hibinium::TemplateFile)
      make_config = HighLine.agree("The file 'hibinium.local.yml' already exists. Do you want to overwrite? [Y/n]") if File.exist?(Hibinium::ConfigFile)
      Dir.mkdir(Hibinium::ConfigFileDir) unless Dir.exist?(Hibinium::ConfigFileDir)

      if make_template
        File.write(Hibinium::TemplateFile, generate_template_yaml)
        puts "make file #{Hibinium::TemplateFile}"
      end
      if make_config
        File.write(Hibinium::ConfigFile, generate_config_yaml)
        puts "make file #{Hibinium::ConfigFile}"
      end
    end

    private

    def generate_template_yaml
      YAML.dump(Hibinium::HibifoTemplate.default_set.to_hash)
    end

    def generate_config_yaml

    end
  end
end