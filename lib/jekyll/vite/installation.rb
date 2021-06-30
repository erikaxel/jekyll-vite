# frozen_string_literal: true

require 'jekyll/vite'

# Internal: Extends the base installation script from Vite Ruby to work for a
# typical Jekyll site.
module Jekyll::Vite::Installation
  JEKYLL_TEMPLATES = Pathname.new(File.expand_path('../../../templates', __dir__))

  # Override: Setup a typical Jekyll site to use Vite.
  def setup_app_files
    cp JEKYLL_TEMPLATES.join('config/jekyll-vite.json'), config.config_path
    append root.join('Rakefile'), <<~RAKE
      require 'jekyll/vite'
      ViteRuby.install_tasks
    RAKE
  end

  # Override: Inject the vite client and sample script to the default HTML template.
  def install_sample_files
    super
    inject_line_before root.join('_layouts/default.html'), '</head>', <<-HTML
    {% vite_client_tag %}
    {% vite_javascript_tag 'application' %}
    HTML
  end
end

ViteRuby::CLI::Install.prepend(Jekyll::Vite::Installation)
