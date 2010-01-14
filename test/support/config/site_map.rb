SiteMap.define do |map|
  map.group(:godzilla, :label => 'Godzilla') do |godzilla|
    godzilla.view :godzilla_about, :url => "'/godzilla/about'" do |about|
      about.view :about_movies, :url => "'/godzilla/about/movies'"
      about.view :about_monsters, :url => "'/godzilla/about/monsters'"
    end
    godzilla.view :godzilla_links, :url => "'/godzilla/links'"
  end
end