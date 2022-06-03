# frozen_string_literal: true

# ## Schema Information
#
# Table name: `esi_grants`
#
# ### Columns
#
# Name                    | Type               | Attributes
# ----------------------- | ------------------ | ---------------------------
# **`id`**                | `bigint`           | `not null, primary key`
# **`approved_at`**       | `datetime`         |
# **`authorized_at`**     | `datetime`         |
# **`expired_at`**        | `datetime`         |
# **`grant_type`**        | `text`             | `not null`
# **`grantable_type`**    | `string`           |
# **`pending_at`**        | `datetime`         |
# **`rejected_at`**       | `datetime`         |
# **`revoked_at`**        | `datetime`         |
# **`scopes`**            | `text`             | `not null, is an Array`
# **`status`**            | `enum`             | `not null`
# **`created_at`**        | `datetime`         | `not null`
# **`updated_at`**        | `datetime`         | `not null`
# **`token_id`**  | `bigint`           |
# **`grantable_id`**      | `bigint`           |
# **`identity_id`**       | `bigint`           |
# **`requester_id`**      | `bigint`           |
#
# ### Indexes
#
# * `index_esi_grants_on_token_id`:
#     * **`token_id`**
# * `index_esi_grants_on_grantable`:
#     * **`grantable_type`**
#     * **`grantable_id`**
# * `index_esi_grants_on_identity_id`:
#     * **`identity_id`**
# * `index_esi_grants_on_requester_id`:
#     * **`requester_id`**
# * `index_unique_esi_grants` (_unique_):
#     * **`token_id`**
#     * **`identity_id`**
#     * **`grantable_type`**
#     * **`grantable_id`**
#     * **`grant_type`**
#     * **`status`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`token_id => esi_tokens.id`**
# * `fk_rails_...`:
#     * **`identity_id => identities.id`**
# * `fk_rails_...`:
#     * **`requester_id => identities.id`**
#
FactoryBot.define do
  factory :esi_grant_structure_market, class: 'ESIGrant::StructureMarket' do
  end
end
