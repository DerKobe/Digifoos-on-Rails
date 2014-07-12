module PlayersHelper

  def big_badge(level, value, prefix, postfix = false)
    content_tag :div, class: "badge #{ level == 'plain' ? level : "alert-#{level}" }" do
      concat(content_tag(:span, class: "prefix #{prefix.downcase}"){ prefix })
      concat(" #{value}")
      concat(content_tag(:span, class: 'postfix'){ " #{postfix}" }) if postfix
    end
  end

end