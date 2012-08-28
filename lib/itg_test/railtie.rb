require 'itg_test'
require 'rails'
module ItgTest
  class Railtie < Rails::Railtie
    railtie_name :itg_test

    rake_tasks do
      load "tasks/test_itg.rake"
    end
  end
end
