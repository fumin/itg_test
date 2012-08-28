module ItgTest
  require 'itg_test/railtie' if defined?(Rails)
  require 'itg_test/test_case'
  require 'itg_test/http_client'

  module_function
  def absolute_file_name_to_class_name abs_fn
    fn = abs_fn.match(%r|^/.*/([a-zA-Z_]+)\.rb$|)[1]
    fn.split('_').map{|w| w.capitalize}.join
  end
end
