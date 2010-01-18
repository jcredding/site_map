SiteMap.define do |map|
  map.group :messages do |messages|
    messages.collection :messages do |list|
      list.member :messages
    end
  end
end