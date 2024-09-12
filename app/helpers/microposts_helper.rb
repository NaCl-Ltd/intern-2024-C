module MicropostsHelper
  def render_with_hashtags(content)
    content.gsub(/#[^\s#]+/) { |w| link_to w, "/microposts/hashtag/#{w[1..]}" }
  end
end
