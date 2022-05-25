# frozen_string_literal: true

# ## Schema Information
#
# Table name: `station_services`
#
# ### Columns
#
# Name               | Type               | Attributes
# ------------------ | ------------------ | ---------------------------
# **`id`**           | `bigint`           | `not null, primary key`
# **`description`**  | `text`             |
# **`name`**         | `text`             | `not null`
# **`created_at`**   | `datetime`         | `not null`
# **`updated_at`**   | `datetime`         | `not null`
#
require 'rails_helper'

RSpec.describe StationService, type: :model do
  describe '.import_all_from_sde' do
    let(:service_ids) do
      YAML.load_file(File.join(Jove.config.sde_path, 'fsd/stationServices.yaml')).keys
    end

    it 'saves each station service' do
      expect(described_class.import_all_from_sde.rows.flatten).to match_array(service_ids)
    end
  end
end
