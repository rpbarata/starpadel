# frozen_string_literal: true

module ClientHelper
  def boolean_badge(value)
    if value
      content_tag(:span, fa_icon("check"), class: "badge badge-pill badge-success")
    else
      content_tag(:span, fa_icon("times"), class: "badge badge-pill badge-danger")
    end
  end
end
