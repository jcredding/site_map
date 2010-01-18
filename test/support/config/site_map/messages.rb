SiteMap.define do |map|
  map.group :project do |project|
    project.collection :messages do |list|
      list.member :messages
    end
  end
end