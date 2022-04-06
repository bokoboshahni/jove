# frozen_string_literal: true

require 'system_helper'

RSpec.describe 'Characters administration', type: :system do
  let(:admin) { create(:admin_user) }

  before do
    sign_in(admin)
  end

  describe 'listing characters' do
    it 'lists characters' do
      characters = create_list(:character, 5)

      visit(dashboard_root_path)
      click_on('Administration')
      click_on('Characters')

      characters.each do |character|
        expect(page).to have_text(character.name)
      end
    end
  end
end
