# frozen_string_literal: true

require 'system_helper'

RSpec.describe 'Alliances administration', type: :system do
  let(:admin) { create(:admin_user) }

  before do
    sign_in(admin)
  end

  describe 'listing alliances' do
    it 'lists alliances' do
      alliances = create_list(:alliance, 5)

      visit(dashboard_root_path)
      click_on('Administration')
      expect(page).to have_text('Alliances')
      click_on('Alliances')

      alliances.each do |alliance|
        expect(page).to have_text(alliance.name)
      end
    end
  end
end
