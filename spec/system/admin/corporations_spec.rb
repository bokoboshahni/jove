# frozen_string_literal: true

require 'system_helper'

RSpec.describe 'Corporations administration', type: :system do
  include_context 'Administration scenarios'

  scenario 'listing corporations' do
    corporations = create_list(:corporation, 5)

    visit(admin_corporations_path)

    corporations.each do |corporation|
      expect(page).to have_text(corporation.name)
    end
  end
end
