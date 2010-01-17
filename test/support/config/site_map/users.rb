SiteMap.define do |map|
  map.group :users do |users|
    users.collection :users, :label => 'User List', :url => "users_path" do |user_list|
      user_list.member :users, :label => 'User :user_name', :url => "user_path", :visible => "false"
    end
  end
end