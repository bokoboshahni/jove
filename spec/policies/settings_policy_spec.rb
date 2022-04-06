# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SettingsPolicy, type: :policy do
  let(:user) { create(:user) }

  subject(:policy) { described_class }

  permissions :index?, :new?, :create?, :show?, :edit?, :update?, :destroy? do
    it 'grants access' do
      expect(policy).to permit(user)
    end
  end
end
