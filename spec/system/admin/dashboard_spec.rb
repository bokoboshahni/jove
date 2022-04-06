# frozen_string_literal: true

require 'system_helper'

RSpec.describe 'Administration dashboard', type: :system do
  let(:user) { create(:admin_user) }

  before { sign_in(user) }

  it 'shows a summary of administration information' do
    visit dashboard_root_path

    find('img.rounded-full').click

    expect(page).to have_text('Administration')

    click_on 'Administration'

    expect(page).to have_text('Administration')
    expect(page).to have_text('Dashboard')
    expect(page).to have_text('Users')
    expect(page).to have_text('Authentication')
  end
end
