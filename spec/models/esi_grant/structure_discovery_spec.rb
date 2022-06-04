# frozen_string_literal: true

# ## Schema Information
#
# Table name: `esi_grants`
#
# ### Columns
#
# Name                  | Type               | Attributes
# --------------------- | ------------------ | ---------------------------
# **`id`**              | `bigint`           | `not null, primary key`
# **`approved_at`**     | `datetime`         |
# **`grantable_type`**  | `string`           |
# **`note`**            | `text`             |
# **`rejected_at`**     | `datetime`         |
# **`revoked_at`**      | `datetime`         |
# **`status`**          | `enum`             | `not null`
# **`type`**            | `text`             | `not null`
# **`used_at`**         | `datetime`         |
# **`created_at`**      | `datetime`         | `not null`
# **`updated_at`**      | `datetime`         | `not null`
# **`grantable_id`**    | `bigint`           |
# **`requester_id`**    | `bigint`           | `not null`
# **`token_id`**        | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_esi_grants_on_grantable`:
#     * **`grantable_type`**
#     * **`grantable_id`**
# * `index_esi_grants_on_requester_id`:
#     * **`requester_id`**
# * `index_esi_grants_on_token_id`:
#     * **`token_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`requester_id => identities.id`**
# * `fk_rails_...`:
#     * **`token_id => esi_tokens.id`**
#
require 'rails_helper'

RSpec.describe ESIGrant::StructureDiscovery, type: :model do
end
