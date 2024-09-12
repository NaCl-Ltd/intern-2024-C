module MicropostsHelper
  def render_with_hashtags(content)
    content.gsub(/#[^\s#]+/) do |w|
      link_to(w, "/microposts/hashtag/#{w[1..]}")
    end.html_safe
  end
end
