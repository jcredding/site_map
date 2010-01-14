SiteMap.define do |map|
  map.group :users do |users|
    users.view :users_list, :label => 'User List', :url => '/users/list' do |list|
      list.view :user, :label => 'User', :url => '/users/1'
    end
  end
end