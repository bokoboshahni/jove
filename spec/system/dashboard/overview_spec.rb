# frozen_string_literal: true

require 'system_helper'

RSpec.describe 'Dashboard', type: :system do
  include_context 'User scenarios'

  scenario 'showing the overview' do
    visit(dashboard_root_path)

    click_on('Open user menu')

    expect(page).to have_text(user.name)
  end
end
