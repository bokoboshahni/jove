# frozen_string_literal: true

require 'system_helper'

RSpec.describe 'Dashboard overview', type: :system do
  let(:user) { create(:registered_user) }

  before { sign_in(user) }

  it 'shows the dashboard overview' do
    visit('/dashboard')
    click_on('Open user menu')

    expect(page).to have_text(user.name)
  end
end
