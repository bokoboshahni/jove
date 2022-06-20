# frozen_string_literal: true

require 'system_helper'

RSpec.describe 'Feature administration', type: :system do
  include_context 'Administration scenarios'

  scenario 'enabling the markets feature' do
    Flipper.disable :markets

    visit(admin_features_path)

    within('#masthead_nav') { expect(page).not_to have_text('Markets') }

    click_on('Enable Markets')
    within('#modal') { click_on('Enable') }
    wait_for_page_reload

    within('#masthead_nav') { expect(page).to have_text('Markets') }
  end

  scenario 'disabling the markets feature' do
    Flipper.enable :markets

    visit(admin_features_path)

    within('#masthead_nav') { expect(page).to have_text('Markets') }

    click_on('Disable Markets')
    within('#modal') { click_on('Disable') }

    wait_for_page_reload

    within('#masthead_nav') { expect(page).not_to have_text('Markets') }
  end
end
