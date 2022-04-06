# frozen_string_literal: true

BetterHtml.config = BetterHtml::Config.new(YAML.safe_load(File.read(Rails.root.join('.better-html.yml'))))

BetterHtml.configure do |config|
  config.template_exclusion_filter = lambda do |filename|
    !filename.start_with?(Rails.root.to_s) ||
      filename.start_with?(Rails.root.join('vendor/bundle').to_s) ||
      filename.start_with?(Rails.root.join('.bundle').to_s)
  end
end
