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

RSpec.describe ESIGrant, type: :model do
  describe '.available?' do
    it 'returns true when there are any approved with authorized tokens' do
      create(:esi_token, :authorized)
      expect(ESIGrant::StructureDiscovery.available?).to be_truthy
    end

    it 'returns false when there are any approved but no authorized tokens' do
      token = create(:esi_token, :authorized)
      token.update(status: :expired)
      expect(ESIGrant::StructureDiscovery.available?).to be_falsey
    end

    it 'returns false when there are no approved' do
      create(:esi_token)
      expect(ESIGrant::StructureDiscovery.available?).to be_falsey
    end
  end

  describe '.unavailable?' do
    it 'returns true when there are no approved' do
      create(:esi_token)
      expect(ESIGrant::StructureDiscovery.unavailable?).to be_truthy
    end

    it 'returns true when there are no approved with authorized tokens' do
      token = create(:esi_token, :authorized)
      token.update(status: :expired)
      expect(ESIGrant::StructureDiscovery.unavailable?).to be_truthy
    end

    it 'returns true when there are any approved with authorized tokens' do
      create(:esi_token, :authorized)
      expect(ESIGrant::StructureDiscovery.unavailable?).to be_falsey
    end
  end

  describe '.pending_available?' do
    it 'returns true when there are no approved and any requests' do
      create(:esi_token)
      expect(ESIGrant::StructureDiscovery.pending_available?).to be_truthy
    end

    it 'returns false when there are no approved and no requests' do
      create(:esi_token, :rejected)
      expect(ESIGrant::StructureDiscovery.pending_available?).to be_falsey
    end
  end

  describe '.preferred' do
    it 'returns nil when there are no authorized grants' do
      expect(ESIGrant::StructureDiscovery.preferred).to be_nil
    end

    it 'returns the first approved grant when there are authorized grants' do
      create_list(:esi_token, 2, :authorized)
      preferred = ESIGrant.first
      expect(ESIGrant::StructureDiscovery.preferred).to eq(preferred)
    end
  end

  describe '.with_token' do
    it 'delegates to #with_token on the preferred token when there are authorized grants' do
      token = create(:esi_token, :authorized)
      preferred = token.grants.first
      allow(ESIGrant::StructureDiscovery).to receive(:preferred).and_return(preferred)

      expect(preferred).to receive(:with_token).and_return(true)
      ESIGrant::StructureDiscovery.with_token
    end
  end

  describe '#with_token' do
    let(:token) { create(:esi_token, :authorized) }

    subject(:grant) { token.grants.first }

    shared_examples 'preconditions not met' do
      it 'returns false' do
        expect(grant.with_token).to be_falsey
      end

      it 'does not yield to the block' do
        expect { |b| grant.with_token(&b) }.not_to yield_control
      end
    end

    context 'when refreshing the token is successful' do
      before do
        allow(token).to receive(:refresh!).and_return(true)
      end

      it 'yields the access token from the token' do
        expect { |b| grant.with_token(&b) }.to yield_with_args(token.access_token)
      end

      it 'returns true' do
        expect(grant.with_token).to be_truthy
      end

      it 'updates the usage timestamp' do
        expect { grant.with_token }.to(change { grant.reload.used_at }.from(nil))
      end
    end

    context 'when the token is not authorized' do
      before { allow(grant).to receive(:authorized?).and_return(false) }

      include_examples 'preconditions not met'
    end

    context 'when the token cannot be refreshed' do
      before { allow(grant.token).to receive(:refresh!).and_return(false) }

      include_examples 'preconditions not met'
    end

    context 'when the grant is not approved' do
      before { allow(grant).to receive(:approved?).and_return(false) }

      include_examples 'preconditions not met'
    end
  end
end
