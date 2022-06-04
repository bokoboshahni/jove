# frozen_string_literal: true

require 'policy_helper'

RSpec.describe CorporationPolicy, type: :policy do
  include_context 'Policy users'
end
