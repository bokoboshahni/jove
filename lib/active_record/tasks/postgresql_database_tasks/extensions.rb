# frozen_string_literal: true

require 'active_record/tasks/postgresql_database_tasks'

module ActiveRecord
  module Tasks
    class PostgreSQLDatabaseTasks
      module Extensions
        def run_cmd(cmd, args, action)
          return super if action != 'dumping'

          super(cmd, args + ['-T', '*._hyper_*'], action)
        end
      end
    end
  end
end
