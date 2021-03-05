Rails.application.configure do

  config.lograge.formatter = Lograge::Formatters::Json.new
  config.lograge.enabled = true
  config.lograge.base_controller_class = ['ActionController::Base']
  config.lograge.custom_options = lambda do |event|
   
    with_parent ||= OpenTelemetry::Context.current
    parent_span_context = OpenTelemetry::Trace.current_span(with_parent).context
    if parent_span_context.valid?
      trace_id = parent_span_context.trace_id.unpack1('H*')
    else 
      trace_id = "none"
    end
    
    {
      request_time: Time.now,
      application: Rails.application.class.parent_name,
      process_id: Process.pid,
      host: event.payload[:host],
      remote_ip: event.payload[:remote_ip],
      ip: event.payload[:ip],
      x_forwarded_for: event.payload[:x_forwarded_for],
      #params: event.payload[:params].to_json,
      rails_env: Rails.env,
      exception: event.payload[:exception],
      exception_object: event.payload[:exception_object],
      request_id: event.payload[:headers]['action_dispatch.request_id'],
      trace_id: trace_id,
      org_id: event.payload[:headers]['OrgId'] || "Unknown"
    }.compact
  end
  config.lograge.keep_original_rails_log = false
  config.lograge.logger = ActiveSupport::Logger.new "#{Rails.root}/log/lograge_#{Rails.env}.log"

  HttpLog.configure do |http_config|
    http_config.prefix = ->{ "" }
    http_config.json_log = true
    http_config.logger = config.lograge.logger
  end

  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  # Run rails dev:cache to toggle caching.
  if Rails.root.join('tmp', 'caching-dev.txt').exist?
    config.action_controller.perform_caching = true
    config.action_controller.enable_fragment_cache_logging = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Store uploaded files on the local file system (see config/storage.yml for options).
  config.active_storage.service = :local

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  host = '0ebe1dc6d40e4a4bb06e0ca7fe138127.vfs.cloud9.us-east-2.amazonaws.com'
  config.action_mailer.default_url_options = { host: host, protocol: 'https' }


  config.action_mailer.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Highlight code that triggered database queries in logs.
  config.active_record.verbose_query_logs = true

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # Raises error for missing translations.
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  # Allow connections to local server.
  config.hosts.clear

end
