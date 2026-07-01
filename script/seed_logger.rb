# frozen_string_literal: true

# Logs every INSERT during seed runs.
# Usage:
#   require Rails.root.join("script/seed_logger")
#   SeedLogger.run { ... }
module SeedLogger
  SKIP_TABLES = %w[schema_migrations ar_internal_metadata].freeze

  class << self
    def run
      @insert_count = 0
      subscribe!
      yield
    ensure
      unsubscribe!
      summary
    end

    def section(title)
      puts "\n[seed] === #{title} ==="
    end

    def info(message)
      puts "[seed] #{message}"
    end

    private

      def subscribe!
        @subscriber = ActiveSupport::Notifications.subscribe("sql.active_record") do |*args|
          event = ActiveSupport::Notifications::Event.new(*args)
          log_insert(event)
        end
      end

      def unsubscribe!
        return unless @subscriber

        ActiveSupport::Notifications.unsubscribe(@subscriber)
        @subscriber = nil
      end

      def log_insert(event)
        sql = event.payload[:sql].to_s
        return unless sql.start_with?("INSERT INTO")

        table = sql[/INSERT INTO "([^"]+)"/, 1]
        return if table.blank? || SKIP_TABLES.include?(table)

        @insert_count += 1
        puts "[seed] INSERT #{table} #{format_attributes(sql, event.payload[:binds])}"
      end

      def format_attributes(sql, binds)
        columns = sql[/INSERT INTO "[^"]+" \(([^)]+)\)/, 1]&.scan(/"([^"]+)"/)&.flatten || []
        values = Array(binds).map { |bind| bind_value(bind) }

        pairs = columns.zip(values).each_with_object([]) do |(column, value), lines|
          next if value.nil?

          lines << "#{column}=#{format_value(value)}"
        end

        pairs.empty? ? "" : "(#{pairs.join(", ")})"
      end

      def bind_value(bind)
        return bind.value_for_database if bind.respond_to?(:value_for_database)

        bind.try(:value)
      end

      def format_value(value)
        string = value.to_s
        return string if string.length <= 80

        "#{string[0, 77]}..."
      end

      def summary
        puts "\n[seed] === complete (#{@insert_count} inserts) ==="
      end
  end
end
