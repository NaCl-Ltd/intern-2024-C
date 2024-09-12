module MicropostsHelper
  def linkify_nickname(text, nicknames_and_urls)
    text = text.encode('UTF-8', invalid: :replace, undef: :replace, replace: '')

    nicknames_and_urls.each do |nickname, url|
      text = text.gsub(/(#{Regexp.escape(nickname)})/, "<a href='#{url}'>\\1</a>").html_safe
    end
    
    text
  end
end
