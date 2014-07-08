# Rails.application.config.after_initialize do
#   ActiveRecord::Base.connection_pool.disconnect!
#
#   ActiveSupport.on_load(:active_record) do
#     config = if ENV['HEROKU_POSTGRESQL_MAUVE_URL'].present?
#                {
#                    'adapter' => 'postgresql',
#                    'url'     => ENV['HEROKU_POSTGRESQL_MAUVE_URL']
#                }
#              else
#                ActiveRecord::Base.configurations[Rails.env] || Rails.application.config.database_configuration[Rails.env]
#              end
#
#     config['reaping_frequency'] = ENV['DB_REAP_FREQ'] || 10 # seconds
#     config['pool']              = ENV['DB_POOL']      || ENV['MAX_THREADS'] || 5
#
#     ActiveRecord::Base.establish_connection(config)
#   end
# end