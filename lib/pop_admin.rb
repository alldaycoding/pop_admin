require "pop_admin/engine"

module PopAdmin

  class << self

    def load!
      register_sprockets if defined?(::Sprockets)
      #configure_sass
    end

    def lib_path
      @lib_path ||= File.dirname(__FILE__)
    end

    def assets_path
      @assets_path ||= File.join lib_path, 'assets'
    end

    def stylesheets_path
      File.join assets_path, 'stylesheets'
    end

    def javascripts_path
      File.join assets_path, 'javascripts'
    end

    def vendor_stylesheets_path
      File.join assets_path, 'vendor', 'stylesheets'
    end

    def vendor_javascripts_path
      File.join assets_path, 'vendor', 'javascripts'
    end

    def vendor_fonts_path
      File.join assets_path, 'vendor', 'fonts'
    end

    def register_sprockets
      Sprockets.append_path(vendor_stylesheets_path)
      Sprockets.append_path(vendor_javascripts_path)
      Sprockets.append_path(vendor_fonts_path)

      Sprockets.append_path(stylesheets_path)
      Sprockets.append_path(javascripts_path)
    end

    def configure_sass
      require 'sass'
      ::Sass.load_paths << vendor_stylesheets_path
      ::Sass.load_paths << stylesheets_path
    end

  end

end

PopAdmin.load!

require 'pop_admin/forms/form_builder.rb'
