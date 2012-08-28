
desc "integration test"
task 'test:itg' => :environment do
  Rails.env = 'test'
  Rake::Task['db:fixtures:load'].invoke
  pid = Process.fork
  if pid.nil?
    exec('rails s -e test -p 3006')
    exec('rails s -e test -p 3006 > /dev/null 2>&1')
  else
    Dir[Dir.pwd + '/test/itg/*.rb'].each {|file|
      require file
      Object.const_get(ItgTest.absolute_file_name_to_class_name(file)).
             new('http://localhost:3006', pid).run_test
    }
  end
end
