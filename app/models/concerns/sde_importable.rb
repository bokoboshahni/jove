# frozen_string_literal: true

module SDEImportable
  extend ActiveSupport::Concern

  included do
    class_attribute :sde_mapper
    self.sde_mapper = nil

    class_attribute :sde_exclude
    self.sde_exclude = []

    class_attribute :sde_rename
    self.sde_rename = {}

    class_attribute :sde_name_lookup
    self.sde_name_lookup = nil
  end

  module ClassMethods
    def sde_names
      @sde_names ||= YAML.load_file(File.join(sde_path, 'bsd/invNames.yaml')).each_with_object({}) do |e, h|
        h[e['itemID']] = e['itemName']
      end
    end

    def sde_path
      Jove.config.sde_path
    end

    def map_sde_attributes(data, context: {}) # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
      data.deep_transform_keys! { |k| k.is_a?(String) ? k.underscore.to_sym : k }
      data.except!(*sde_exclude)

      sde_mapper&.call(data, context:)

      data.transform_keys! { |k| sde_rename.fetch(k, k) }

      if sde_name_lookup.is_a?(Symbol)
        data[:name] = sde_names.fetch(data.fetch(sde_name_lookup))
      elsif sde_name_lookup
        data[:name] = sde_names.fetch(data.fetch(:id))
      end

      attribute_names.reject { |a| %w[created_at updated_at].include?(a) }
                     .map(&:to_sym).each { |a| data[a] = nil unless data.key?(a) }

      data
    end
  end
end
