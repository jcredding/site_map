SiteMap.define do |map|
  map.group :messages do |messages|
    messages.view :messages_list, :label => 'Message List', :url => '/messages/list' do |list|
      list.view :message, :label => 'Message', :url => '/messages/1'
    end
  end
end