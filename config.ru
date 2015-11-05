# This file is used by Rack-based servers to start the application.

if defined? Unicorn
  # Unicorn self-process killer
  require 'unicorn/worker_killer'

  # Max requests per worker
  # use Unicorn::WorkerKiller::MaxRequests, 3072, 4096

  # Max memory size (RSS) per worker
  use Unicorn::WorkerKiller::Oom, (220 * (1024**2)), (300 * (1024**2))
end

require ::File.expand_path('../config/environment', __FILE__)
run Rails.application
