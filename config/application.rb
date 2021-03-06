require File.expand_path('../boot', __FILE__)

require 'rails/all'

# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Otwarchive
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)
    config.autoload_paths += %W(#{Rails.root}/lib)
    config.autoload_paths += %W(#{Rails.root}/app/sweepers)
    %w(
      challenge_models
      tagset_models
      indexing
      search
      feedback_reporters
      potential_matcher
    ).each do |dir|
      config.autoload_paths << "#{Rails.root}/app/models/#{dir}"
    end

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]
    config.plugins = [ :all ]

    # I18n validation deprecation warning fix
    #

    I18n.config.enforce_available_locales = false
    I18n.config.available_locales = [:en, :ar, :ca, 'zh-CN', :cs, :nl, :fi, :fr, :de, :he, :hu, :id,
      :it, :ja, :ko, :lt, :pl, 'pt-BR', :ru, :es, :sv, :tr]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer
    config.active_record.observers = :comment_observer, :work_observer, :creation_observer, :collection_preference_observer, :kudo_observer, :response_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'
    config.time_zone = 'Eastern Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # JavaScript files you want as :defaults (application.js is always included).
    # config.action_view.javascript_expansions[:defaults] = %w(jquery rails)

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    config.action_mailer.default_url_options = { :host => "archiveofourown.org" }

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:content, :password, :terms_of_service_non_production]

    # configure middleware

    ### things I'm preserving here from our Rails 2 environment.rb that we might or might not need

    # Use SQL instead of Active Record's schema dumper when creating the test database.
    # This is necessary if your schema can't be completely dumped by the schema dumper,
    # like if you have constraints or database-specific column types
    config.active_record.schema_format = :sql

    ### end of preservation section

    # handle errors with custom error pages:
    config.exceptions_app = self.routes

    # Bring the log under control
    config.lograge.enabled = true

  end
end
