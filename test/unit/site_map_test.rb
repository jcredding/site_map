require 'test/helper'

class SiteMapTest < Test::Unit::TestCase

  def setup
    @subject = SiteMap
    @config = @subject.send(:config)
  end

  # SiteMap.build
  def test_should_have_build_method
    assert @subject.respond_to?(:build)
  end

  def test_build_should_load_the_definition_file
    path = File.expand_path("../../support/build_test_site_map.rb", __FILE__)
    @config.definition_file = Pathname.new(path)

    assert File.exists?(@config.definition_file)
    assert !defined?(SITEMAP_LOADED)
    assert_nothing_raised{ @subject.build }
    assert !!defined?(SITEMAP_LOADED) && SITEMAP_LOADED
  end

  def test_build_should_not_raise_a_load_error
    assert !File.exists?(@config.definition_file)
    assert_nothing_raised{ @subject.build }
  end

  # SiteMap.define
  def test_should_have_define_method
    assert @subject.respond_to?(:define)
  end

  def test_define_should_require_a_block
    assert_raises(ArgumentError){ @subject.define }
  end

  # need to reset the SiteMap
  def teardown
    @subject.instance_variable_set("@map", nil)
    @subject.instance_variable_set("@config", nil)
    @subject.instance_variable_set("@builder", nil)
  end

end
