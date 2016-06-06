require 'rails/generators/migration'

module ActsAsPushable
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      source_root File.expand_path('../templates', __FILE__)

      def copy_initializer_file
        template "initializer.rb", "config/initializers/acts_as_pushable.rb"
      end

      def copy_migration_files
        migration_template "migration/devices.rb", "db/migrate/devices.rb"
      end

      def self.next_migration_number(dirname)
        if ActiveRecord::Base.timestamped_migrations
          sleep 1 # make sure each time we get a different timestamp
          Time.new.utc.strftime("%Y%m%d%H%M%S")
        else
          "%.3d" % (current_migration_number(dirname) + 1)
        end
      end
    end
  end
end
