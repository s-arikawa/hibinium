require 'hibinium'
require 'hibinium/command'
require 'hibinium/command/model/hibifo_template'
require 'hibinium/command/model/hibifo_config'
require 'yaml'
require 'highline'

module Hibinium
  class Command < Thor
    desc 'init', 'hibinium configuration file make up!'

    def init
      make_template = true
      make_config = true

      make_template = HighLine.agree("The file 'hibinium.template.yml' already exists. Do you want to overwrite? [Y/n]") if File.exist?(TemplateFilePath)
      make_config = HighLine.agree("The file 'hibinium.local.yml' already exists. Do you want to overwrite? [Y/n]") if File.exist?(ConfigFilePath)
      Dir.mkdir(ConfigFileDirPath) unless Dir.exists?(ConfigFileDirPath)

      if make_template
        File.write(TemplateFilePath, generate_template_yaml)
        puts "make file #{TemplateFilePath}"
      end
      if make_config
        File.write(ConfigFilePath, generate_config_yaml)
        puts "make file #{ConfigFilePath}"
      end
    end

    private

    def generate_template_yaml
      YAML.dump(HibifoTemplate.default_set.to_hash)
    end

    def generate_config_yaml
      YAML.dump(HibifoConfig.default_set.to_hash)
    end
  end
end