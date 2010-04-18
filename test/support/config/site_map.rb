SiteMap.define do |map|
  map.group(:godzilla, :label => 'Godzilla') do |godzilla|
    godzilla.view :godzilla_about, :url => "'/godzilla/about'" do |about|
      about.view :about_movies, :url => "'/godzilla/about/movies'"
      about.view :about_monsters, :url => "'/godzilla/about/monsters'"
      about.view :about_rodan, :url => "'/godzilla/about/rodan'"
    end
    godzilla.view :godzilla_links, :url => "'/godzilla/links'"
    godzilla.alias :godzilla_urls, :godzilla_links
  end
end