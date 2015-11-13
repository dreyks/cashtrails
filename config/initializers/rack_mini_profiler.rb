if defined?(Rack::MiniProfiler)
  # Rack::MiniProfiler has to go after Rack::Deflater or it will inject JS into already gzipped body
  if Rails.application.middleware.instance_variable_get(:@operations).flatten.include?(Rack::Deflater)
    Rails.application.middleware.delete(Rack::MiniProfiler)
    Rails.application.middleware.insert_after(Rack::Deflater, Rack::MiniProfiler)
  end


  Rack::MiniProfiler::ActiveRecordInstrumentation.class_eval do
    def log_with_miniprofiler(*args, &block)
      return log_without_miniprofiler(*args, &block) unless SqlPatches.should_measure?

      sql, name, binds = args
      start            = Time.now
      rval             = log_without_miniprofiler(*args, &block)

      # Don't log schema queries if the option is set
      return rval if Rack::MiniProfiler.config.skip_schema_queries and name =~ /SCHEMA/

      elapsed_time = SqlPatches.elapsed_time(start)

      # adding binds to sql for logging purposes
      # checking if ActiveRecord::LogSubscriber is here
      ar_log_subscriber = ActiveSupport::LogSubscriber.subscribers.find do |s|
        s.is_a? ActiveRecord::LogSubscriber
      end
      if ar_log_subscriber
        rendered_binds = binds.map { |b| ar_log_subscriber.render_bind(*b) }
        sql = "#{sql} #{rendered_binds}"
      end

      Rack::MiniProfiler.record_sql(sql, elapsed_time)
      rval
    end
  end
  ActiveRecord::ConnectionAdapters::AbstractAdapter.send(:alias_method, :log, :log_with_miniprofiler)
end
