# frozen_string_literal: true

class OldMigrations < ActiveRecord::Migration[7.0]
  REQUIRED_VERSION = 20_220_617_134_849

  def up
    return unless ActiveRecord::Migrator.current_version < REQUIRED_VERSION

    raise '`bin/rails db:schema:load` must be run prior to `bin/rails db:migrate`'
  end
end
