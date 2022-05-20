# frozen_string_literal: true

require 'system_helper'

RSpec.describe 'Authorization behavior', type: :system do
  include_context 'User scenarios'

  scenario 'disallowed action' do
    visit(admin_login_permits_path)

    expect(page).to have_text('not authorized')
  end
end
