# frozen_string_literal: true

require 'csv'

module Jove
  module SDE
    module Importers
      class UnitImporter < BaseImporter
        self.sde_model = Unit

        def import_all
          data = CSV.read(Rails.root.join('db/units.csv'), headers: true)
          progress&.update(total: data.count)
          rows = data.map do |orig|
            record = { id: orig.fetch('unitID'), name: orig.fetch('unitName') }
            progress&.advance
            record
          end
          sde_model.upsert_all(rows, returning: false) unless rows.empty?
        end
      end
    end
  end
end
