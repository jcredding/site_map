SiteMap.define do |map|
  map.group(:godzilla, :label => 'Godzilla') do |godzilla|
    godzilla.view :godzilla_about, :url => "'/godzilla/about'"
  end
end