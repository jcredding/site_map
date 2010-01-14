require File.dirname(__FILE__) + '/../test_helper'

class MapTest < Test::Unit::TestCase

  context "an instance of SiteMap::Map" do
    setup{ @map = SiteMap.map }
    subject{ @map }

    [:view_nodes, :group, :view].each do |method|
      should "respond to #{method}" do
        assert subject.respond_to?(method)
      end
    end
  end

end