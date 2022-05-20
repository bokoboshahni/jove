# frozen_string_literal: true

require 'system_helper'

RSpec.describe 'Homepage', type: :system do
  scenario 'visiting the homepage' do
    visit(root_path)

    expect(page).to have_content('Log in with EVE Online')
  end
end
