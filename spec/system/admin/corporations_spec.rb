# frozen_string_literal: true

require 'system_helper'

RSpec.describe 'Corporations administration', type: :system do
  let(:admin) { create(:admin_user) }

  before do
    sign_in(admin)
  end

  describe 'listing corporations' do
    it 'lists corporations' do
      corporations = create_list(:corporation, 5)

      visit(dashboard_root_path)
      click_on('Administration')
      expect(page).to have_text('Corporations')
      click_on('Corporations')

      corporations.each do |corporation|
        expect(page).to have_text(corporation.name)
      end
    end
  end
end
