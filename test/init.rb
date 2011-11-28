FILE_DIRNAME = File.dirname(__FILE__)
$:.unshift FILE_DIRNAME
$:.unshift FILE_DIRNAME+"/../lib"

require 'rubygems'
require 'test/unit'
require 'lib/muj'

class TestMuj < Test::Unit::TestCase
  def test_tilt
    tmpl = Tilt.new(FILE_DIRNAME+"/test.muj")
    r = tmpl.render(nil,{:user => {:first_name => "Sophia"}})
    assert_equal(r, "Sophia")
  end

  def test_muj 
    r = Muj.render(File.open(FILE_DIRNAME+"/test.muj").read,{:user => {:first_name => "Sophia"}})
    assert_equal(r, "Sophia")
  end

  def test_muj_with_yaml
    r = Muj.render_with_yaml(File.open(FILE_DIRNAME+"/test.muj").read,"{'user': {'first_name': 'Sophia'}}")
    assert_equal(r, "Sophia")
  end
end
