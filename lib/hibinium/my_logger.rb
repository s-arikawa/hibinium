require 'logger'
module Hibinium
  # Logger
  module MyLogger
    def log
      if @logger.nil?
        @logger = MyLogger.new_logger
      end
      @logger
    end

    def self.logger
      new_logger
    end

    private
    def self.new_logger
      Logger.new(STDOUT)
    end
  end
end