# encoding: utf-8
require 'rails/railtie'
require 'ti_hadoop_store/model'
require 'logger'

module TiHadoopStore
  class Railtie < ::Rails::Railtie
    config.ti_hadoop_store = ActiveSupport::OrderedOptions.new
    config.ti_hadoop_store.logger = nil
    config.ti_hadoop_store.databases = nil
  end

  class Config
    def self.logger
      @logger ||= Railtie.config.ti_hadoop_store.logger || \
        Rails.respond_to?(:logger) ? Rails.logger : Logger.new($stdout)
    end

    def self.databases
      @databases ||= Railtie.config.ti_hadoop_store.databases || \
        if Rails.respond_to?(:configuration)
          Rails.configuration.database_configuration
        else {} end
    end
  end
end
