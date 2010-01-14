SiteMap.define do |map|
  map.group(:godzilla, :label => 'Godzilla') do |godzilla|
    godzilla.view :about, :url => "'/godzilla/about'"
  end
end