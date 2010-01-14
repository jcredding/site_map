require File.dirname(__FILE__) + '/../test_helper'

class SiteMapTest < Test::Unit::TestCase

  context "SiteMap module" do
    subject{ SiteMap }

    [:define, :setup, :[]].each do |method|
      should "respond to #{method}" do
        assert subject.respond_to?(method)
      end
    end

    context "define method" do
      setup{ SiteMap.define{|map| @map = map} }
      subject{ @map }

      should "yield it's map to given block" do
        assert subject.kind_of?(SiteMap::Map)
      end
    end
  end

end