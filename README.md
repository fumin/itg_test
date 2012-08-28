# itg_test - simple integration test framework
## Description
For Rails apps that are too complicated to be tested with the
builtin integration test, such as apps that spawn threads
that update the same database table.  
itg_test overcomes this obstacle by simply starting a server
and a client in separate processes.  

## Installation
`gem install itg_test`

## Usage
* Create a `itg` folder under Rail's default test folder by running
  `mkdir test/itg`.
  Now your directory structure should look like
  ```
  $ls test
  fixtures  functional  integration  itg  test_helper.rb  unit
  ```
* Write integration tests as you would with Rail's default
  integration test framework. Remember to place them under
  the `itg` folder instead of Rail's default `integration` folder.  
  For example, create `test/itg/your_app_test.rb` with the following contents
  ```
  require 'itg_test'

  class YourAppTest < ItgTest::TestCase
    test 'a complete test' do
      get '/peanuts'
      assert_select 'h3 p:nth-child(3)', 'very yummy'
      ...
    end
  end
  ```
* Run your itg_test tests with `rake test:itg`
* itg_test supports the common Rails integration test helpers,
  including `assert_equal`, `assert_difference` and `assert_select` etc.
* You might find the following script that runs all
  Rails and itg_test tests in one shot handy
  ```
  desc "all tests"
  task 'test:all' => :environment do
      Rake::Task['test'].invoke
      Rake::Task['test:itg'].invoke
  end
  ```

## CONTRIBUTORS:

* awaw fumin (@awawfumin)

## LICENSE:

Apache License 2.0

Copyright (c) 2011-2012, Cardinal Blue

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   <http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
