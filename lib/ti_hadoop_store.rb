# encoding: utf-8
require 'rails/railtie'
require 'ti_hadoop_store/model'
require 'logger'

module TiHadoopStore
  class Railtie < ::Rails::Railtie
    config.ti_hadoop_store = ActiveSupport::OrderedOptions.new
    config.ti_hadoop_store.logger = Logger.new($stdout)
  end

  class Config
    def self.logger
      Railtie.config.ti_hadoop_store.logger
    end

    def self.databases
      Rails.configuration.database_configuration
    end
  end
end
