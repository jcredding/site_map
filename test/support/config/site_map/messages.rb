SiteMap.define do |map|
  map.group :messages do |messages|
    messages.view :messages__index, :label => 'Message List', :url => '/messages/list' do |list|
      list.view :messages__show, :label => 'Message', :url => '/messages/1'
    end
  end
end