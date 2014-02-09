module Bootstrap3
  module HelperMethods
    def icon(icon_name, content = nil)
      i = content_tag(:span, nil, class: "glyphicon glyphicon-#{icon_name}")
      content ? i + content_tag(:span, ' ' + content) : i
    end
  end
end
