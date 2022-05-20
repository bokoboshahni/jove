# frozen_string_literal: true

require 'system_helper'

RSpec.describe 'Alliances administration', type: :system do
  include_context 'Administration scenarios'

  scenario 'listing alliances' do
    alliances = create_list(:alliance, 5)

    visit(admin_alliances_path)

    alliances.each do |alliance|
      expect(page).to have_text(alliance.name)
    end
  end
end
