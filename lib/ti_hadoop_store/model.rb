# encoding: utf-8
require 'timeout'
require 'impala'

module TiHadoopStore
  class Model
    def self.quote(s)
      "'#{s.gsub(/\\/, '\&\&').gsub(/'/, "''")}'"
    end

    def self.label
      "#{Rails.env}_hadoop"
    end

    def self.config
      Config.databases[label]
    end

    def self.connect!(_options = {})
      unless config && config['adapter'] && \
             config['host'] && config['port']
        fail KeyError, "No valid configuration found for #{label}"
      end
      case config['adapter']
      when 'impala'
        Impala.connect(config['host'], config['port'])
      else
        fail NotImplementedError, "Unknown adapter #{config[adapter]}"
      end
    end

    def self.connection
      @connection ||= connect!
    end

    def self.close
      @connection.close if @connection
      @connection = nil
    end

    def self.database
      unless config && config['database']
        fail KeyError, "No directory configuration found for #{label}"
      end
      config['database']
    end

    def self.timeout
      config && config['timeout'] || 0
    end

    def self.query(statement)
      pool = config && config["pool"] || ""
      Config.logger.info "Impala query:\"#{statement}\""
      Timeout.timeout(timeout / 1000) do
        connection.query(statement, request_pool: pool)
      end
    end

    def self.table_exists?(table)
      quoted_table = quote table.split('.').last
      show_tables = "SHOW TABLES IN #{database} LIKE #{quoted_table}"

      begin
        tables = query show_tables
      ensure
        close
      end

      !tables.empty?
    end
  end
end
