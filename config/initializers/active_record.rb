# frozen_string_literal: true

ActiveSupport.on_load(:active_record) do
  require 'active_record/tasks/postgresql_database_tasks/extensions'

  ActiveRecord::Tasks::PostgreSQLDatabaseTasks.prepend(
    ActiveRecord::Tasks::PostgreSQLDatabaseTasks::Extensions
  )
end
