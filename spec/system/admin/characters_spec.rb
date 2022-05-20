# frozen_string_literal: true

require 'system_helper'

RSpec.describe 'Characters administration', type: :system do
  include_context 'Administration scenarios'

  scenario 'listing characters' do
    characters = create_list(:character, 5)

    visit(admin_characters_path)

    characters.each do |character|
      expect(page).to have_text(character.name)
    end
  end
end
