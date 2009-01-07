class DbBackendGenerator < Rails::Generator::Base
  def initialize(runtime_args, runtime_options = {})
    super
  end

  def manifest
    record do |m|
      m.migration_template 'migration.rb', 
                           'db/migrate', 
                           :migration_file_name => "create_globalize2"
    end
  end

  protected
    def banner
      "Usage: #{$0} db_backend" 
    end
end

