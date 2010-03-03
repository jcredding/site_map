module SiteMap
  module Exceptions

    # This is an exception raised when an alias mapping is used and the node to be aliased does not
    # exist
    class NonExistantViewNode < StandardError
    end

  end
end