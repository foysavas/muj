FILE_DIR = File.dirname(__FILE__)
FIXTURE_DIR = FILE_DIR + "/fixtures"
$:.unshift FILE_DIR
$:.unshift FILE_DIR+"/../lib"

require 'rubygems'
require 'test/unit'
require 'lib/muj'

class TestMuj < Test::Unit::TestCase
  def setup
    @data1 = {:user => {:first_name => "Sophia"}}
    @tmpl1_fn = FIXTURE_DIR+"/test.muj"
    @tmpl1 = File.open(@tmpl1_fn).read
    @tmpl2 = File.open(FIXTURE_DIR+"/test-partials.muj").read
  end

  def test_tilt
    tmpl = Tilt.new(@tmpl1_fn)
    r = tmpl.render(nil,{:user => {:first_name => "Sophia"}})
    assert_equal(r, "Hi Sophia!")
  end

  def test_muj
    r = Muj.render(@tmpl1,@data1)
    assert_equal(r, "Hi Sophia!")
  end

  def test_muj_with_yaml
    r = Muj.render_with_yaml(@tmpl1,"{'user': {'first_name': 'Sophia'}}")
    assert_equal(r, "Hi Sophia!")
  end

  def test_partials
    partials = Muj::Partials.new(FIXTURE_DIR)
    assert_equal(true,partials.__exists("test"))
  end

  def test_with_partials
    r = Muj.render(@tmpl2,@data1,{'partials' => FIXTURE_DIR})
    assert_equal(r, "Hi Sophia!")
  end
end
