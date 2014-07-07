Rails.application.config.after_initialize do
  ActiveRecord::Base.connection_pool.disconnect!

  ActiveSupport.on_load(:active_record) do
    config = ActiveRecord::Base.configurations[Rails.env] || Rails.application.config.database_configuration[Rails.env]
    config['reaping_frequency'] = ENV['DB_REAP_FREQ'] || 10 # seconds
    config['pool']              = ENV['DB_POOL']      || ENV['MAX_THREADS'] || 5
    config['url']               = ENV['HEROKU_POSTGRESQL_MAUVE_URL']

    ActiveRecord::Base.establish_connection(config.slice('adapter', 'pool', 'reaping_frequency', 'url'))
  end
end