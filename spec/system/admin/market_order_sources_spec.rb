# frozen_string_literal: true

require 'system_helper'

RSpec.describe 'Market order sources administration', type: :system do
  include_context 'Administration scenarios'
  include_context 'Market scenarios'
end
