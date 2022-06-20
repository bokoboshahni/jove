# frozen_string_literal: true

# ## Schema Information
#
# Table name: `structures`
#
# ### Columns
#
# Name                        | Type               | Attributes
# --------------------------- | ------------------ | ---------------------------
# **`id`**                    | `bigint`           | `not null, primary key`
# **`discarded_at`**          | `datetime`         |
# **`esi_etag`**              | `text`             | `not null`
# **`esi_expires_at`**        | `datetime`         | `not null`
# **`esi_last_modified_at`**  | `datetime`         | `not null`
# **`name`**                  | `text`             | `not null`
# **`position_x`**            | `decimal(, )`      | `not null`
# **`position_y`**            | `decimal(, )`      | `not null`
# **`position_z`**            | `decimal(, )`      | `not null`
# **`created_at`**            | `datetime`         | `not null`
# **`updated_at`**            | `datetime`         | `not null`
# **`corporation_id`**        | `bigint`           | `not null`
# **`solar_system_id`**       | `bigint`           | `not null`
# **`type_id`**               | `bigint`           |
#
# ### Indexes
#
# * `index_structures_on_corporation_id`:
#     * **`corporation_id`**
# * `index_structures_on_solar_system_id`:
#     * **`solar_system_id`**
# * `index_structures_on_type_id`:
#     * **`type_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`corporation_id => corporations.id`**
# * `fk_rails_...`:
#     * **`solar_system_id => solar_systems.id`**
# * `fk_rails_...`:
#     * **`type_id => types.id`**
#
require 'rails_helper'

RSpec.describe Structure, type: :model do
  subject(:structure) { create(:structure) }

  describe '#enable_market_source' do
    let(:user) { create(:registered_user) }
    let(:identity) { user.default_identity }

    it 'creates a new ESI token for the structure' do
      expect { subject.enable_market_source(identity, identity_id: identity.id) }.to(
        change { ESIToken.find_by(requester: identity, identity:, grant_type: :structure_market) }
          .from(nil)
      )
    end

    it 'creates the market order source for the structure' do
      expect { subject.enable_market_source(identity, identity_id: identity.id) }.to(
        change { subject.market_order_source }
          .from(nil)
      )
    end
  end
end
