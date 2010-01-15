SiteMap.define do |map|
  map.group :users do |users|
    users.view :users__index, :label => 'User List', :url => 'users_path' do |list|
      list.view :users__show, :label => 'User :user_name', :url => 'user_path', :visible => 'false'
    end
  end
end