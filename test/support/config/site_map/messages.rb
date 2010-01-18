SiteMap.define do |map|
  map.group :project do |project|
    project.collection :messages do |list|
      list.member :messages
      list.member_view :messages, :edit
    end
    project.collection_view :messages, :new
  end
end