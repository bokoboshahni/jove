# frozen_string_literal: true

module BlueprintActivityItem
  extend ActiveSupport::Concern

  include BlueprintActivityEnum

  included do
    belongs_to :activity, class_name: 'BlueprintActivity', foreign_key: %i[blueprint_id activity]
  end
end
