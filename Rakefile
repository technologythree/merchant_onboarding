# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'

# class Rails::Application
#   include Rake::DSL if defined?(Rake::DSL)
# end

# Rake Fix Code start
# NOTE: change 'Anelis' to your app's module name (see config/application.rb)
module ::MerchantOnboarding
  class Application
    include Rake::DSL
  end
end

module ::RakeFileUtils
  extend Rake::FileUtilsExt
end
# Rake Fix Code end

MerchantOnboarding::Application.load_tasks
