# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ESISyncable, type: :model do
  subject(:klass) { Class.new { include(described_class) } }
end
