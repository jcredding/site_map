SiteMap.define do |map|
  map.group :project do |project|
    project.collection :messages do |list|
      list.member :messages
      list.member_view :messages, :edit
      list.member_view :messages, :approve
    end
    project.collection_view :messages, :new
    project.collection_view :messages, :approved
  end
end