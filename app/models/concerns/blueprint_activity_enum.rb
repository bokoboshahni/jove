# frozen_string_literal: true

module BlueprintActivityEnum
  extend ActiveSupport::Concern

  included do
    enum activity: %i[
      copying
      invention
      manufacturing
      reaction
      research_material
      research_time
    ].index_with(&:to_s)
  end
end
