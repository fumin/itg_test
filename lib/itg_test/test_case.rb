require 'itg_test/http_client'
require 'nokogiri'

module Declarative
  def test name, &block
    test_name = "test_#{name.gsub(/\s+/,'_')}".to_sym
    define_method test_name, &block
  end
end

module ItgTest; end
class ItgTest::TestCase
  extend Declarative
  def run_test
    methods.select{|m| /^test_\w+$/ =~ m.to_s}.each{|m| send(m); print "."}
    puts "\nFinished Tests"
  rescue Exception => e
    puts "#{e.class}: #{e}"
    puts e.backtrace
  ensure
    wait_exit
  end

  def initialize url, pid
    @pid = pid
    @client = ItgTest::HTTPClient.new url
  end

  def post path, data
    @response = @client.post path, data
  end

  def get path
    @response = @client.get path
  end

  def assert_difference expression, difference=1
    exs = [expression].flatten
    before = exs.map{|e| eval e}
    yield
    exs.each_with_index{ |e, i| assert_equal(before[i] + difference, eval(e), e) }
  end

  def assert_select selector, content
    unless Nokogiri::HTML(@response).at_css(selector).try(:content) == content
      raise "#{content} doesn't match #{selector} of\n#{@response}"
    end
  end

  def assert_equal a, b, msg=""
    raise "Expected #{a} == #{b} #{msg}" unless a == b
  end

  def wait_exit
    child_pids(@pid).each{|p| Process.kill "INT", p} # kill grand_children
    Process.kill "INT", @pid # kill child
    Process.wait
    exit
  end

  def child_pids pid
    pipe = IO.popen("ps -ef | grep #{pid}")
    pipe.readlines.map do |line|
      parts = line.split(/\s+/)
      parts[2] if parts[3] == pid.to_s and parts[2] != pipe.pid.to_s
    end.compact.map(&:to_i)
  end
end
