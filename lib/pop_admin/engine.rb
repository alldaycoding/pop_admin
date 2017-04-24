module PopAdmin
  class Engine < ::Rails::Engine
    isolate_namespace PopAdmin

    config.autoload_paths += Dir[Engine.root.join('app', 'helpers')]
  end
end
