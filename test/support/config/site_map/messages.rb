SiteMap.define do |map|
  map.collection :projects do |projects|
    projects.collection :messages do |list|
      list.member :messages
      list.member_view :messages, :edit
      list.member_view :messages, :approve
    end
    projects.collection_view :messages, :new
    projects.collection_view :messages, :approved
  end
end