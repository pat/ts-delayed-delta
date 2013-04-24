class SphinxController
  def initialize
    if config.respond_to?(:searchd)
      config.searchd.mysql41 = 9307
    else
      config.port = 9313
    end
  end

  def setup
    if config.respond_to?(:searchd)
      FileUtils.mkdir_p config.indices_location

      config.render_to_file && index

      ThinkingSphinx::Configuration.reset
    else
      FileUtils.mkdir_p config.searchd_file_path

      config.build
      config.controller.index

      ThinkingSphinx::Configuration.instance.reset
    end

    ActiveSupport::Dependencies.clear

    if config.respond_to?(:searchd)
      config.index_paths.each do |path|
        Dir["#{path}/**/*.rb"].each { |file| $LOADED_FEATURES.delete file }
      end

      config.searchd.mysql41 = 9307
      config.settings['quiet_deltas']      = true
      config.settings['attribute_updates'] = true
    else
      config.port = 9313
      ThinkingSphinx.suppress_delta_output = true
      ThinkingSphinx.updates_enabled       = true
      ThinkingSphinx.deltas_enabled        = true
    end
  end

  def start
    config.controller.start
  end

  def stop
    config.controller.stop
  end

  def index(*indices)
    config.controller.index *indices
  end

  private

  def config
    ThinkingSphinx::Configuration.instance
  end
end
