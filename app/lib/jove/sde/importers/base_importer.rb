# frozen_string_literal: true

module Jove
  module SDE
    module Importers
      class BaseImporter
        class_attribute :sde_mapper
        self.sde_mapper = nil

        class_attribute :sde_exclude
        self.sde_exclude = []

        class_attribute :sde_file
        self.sde_file = nil

        class_attribute :sde_files
        self.sde_files = []

        class_attribute :sde_import_mode
        self.sde_import_mode = :merge

        class_attribute :sde_model
        self.sde_model = nil

        class_attribute :sde_rename
        self.sde_rename = {}

        class_attribute :sde_name_lookup
        self.sde_name_lookup = nil

        class_attribute :sde_localized
        self.sde_localized = []

        def initialize(sde_path:, progress: nil)
          @sde_path = sde_path
          @progress = progress
        end

        def import_all
          case sde_import_mode
          when :merge
            import_merged
          end
        end

        protected

        attr_reader :progress, :sde_path

        def names
          @names ||=
            begin
              names_path = File.join(sde_path, 'bsd/invNames.yaml')
              YAML.load_file(names_path).each_with_object({}) do |e, h|
                h[e['itemID']] = e['itemName']
              end
            end
        end

        def import_merged
          data = YAML.load_file(File.join(sde_path, sde_file))
          progress&.update(total: data.count)
          rows = data.map do |id, orig|
            record = map_sde_attributes(orig, id:)
            progress&.advance
            record
          end
          sde_model.upsert_all(rows)
        end

        def map_sde_attributes(data, id: nil, model_class: nil, context: {}) # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
          data.deep_transform_keys! { |k| k.is_a?(String) ? k.underscore.to_sym : k }

          sde_mapper&.call(data, context:)

          data.transform_keys! { |k| sde_rename.fetch(k, k) }

          if sde_name_lookup.is_a?(Symbol)
            data[:name] = names.fetch(data.fetch(sde_name_lookup))
          elsif sde_name_lookup
            data[:name] = names.fetch(data.fetch(:id))
          end

          data[:id] = id if id

          sde_localized.each do |field|
            key = data.key?(:"#{field}_id") ? :"#{field}_id" : field
            data[field] = data.delete(key)&.fetch(:en, '') if data[key].is_a?(Hash)
          end

          data.except!(*sde_exclude)

          attribute_names = (model_class || sde_model).attribute_names
          attribute_names.reject { |a| %w[created_at updated_at].include?(a) }
                         .map(&:to_sym).each { |a| data[a] = nil unless data.key?(a) }

          data
        end
      end
    end
  end
end
