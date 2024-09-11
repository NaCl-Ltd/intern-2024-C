module MicropostsHelper
    def linkify_nickname(text, nickname, url)
        text = text.encode('UTF-8', invalid: :replace, undef: :replace, replace: '')
        nickname = nickname||'text'
        text.gsub(/(#{Regexp.escape(nickname)})/, "<a href='#{url}'>\\1</a>").html_safe
      end
end
