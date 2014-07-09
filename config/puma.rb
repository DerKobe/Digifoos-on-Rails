workers Integer(ENV['PUMA_WORKERS'] || 3)
threads Integer(ENV['MIN_THREADS']  || 1), Integer(ENV['MAX_THREADS'] || 5)

preload_app!

rackup      DefaultRackup
port        ENV['PORT']     || 3000
environment ENV['RACK_ENV'] || 'development'

on_worker_boot do
  # worker specific setup
  ActiveSupport.on_load(:active_record) do
    config = if ENV['DATABASE_URL'].present?
               {
                   'adapter' => 'postgresql',
                   'url'     => ENV['DATABASE_URL']
               }
             else
               ActiveRecord::Base.configurations[Rails.env] || Rails.application.config.database_configuration[Rails.env]
             end

    config['reaping_frequency'] = ENV['DB_REAP_FREQ'] || 10 # seconds
    config['pool']              = ENV['DB_POOL']      || ENV['MAX_THREADS'] || 5

    ActiveRecord::Base.establish_connection(config)
  end
end
