if defined?(Rack::MiniProfiler)
  if Rails.application.middleware.instance_variable_get(:@operations).flatten.include?(Rack::Deflater)
    Rails.application.middleware.delete(Rack::MiniProfiler)
    Rails.application.middleware.insert_after(Rack::Deflater, Rack::MiniProfiler) # otherwise Miniprofiler tries to inject JS into gzipped body
  end
end
