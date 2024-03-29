# frozen_string_literal: true

module ApplicationHelper
  def active_tab(tab, index, page)
    if index == 0 && page.blank?
      "active"
    elsif page.present? && tab == "tab-profile"
      "active"
    else
      ""
    end
  end

  def new_active_tab(tab, index, params)
    if params[:"#{tab}_page"].present? && params.keys.count { |p| p.include?("_page") } >= 2 && index == 2
      "active"
    elsif params[:"#{tab}_page"].present? && params.keys.count { |p| p.include?("_page") } >= 2 && index != 2
      ""
    elsif params[:"#{tab}_page"].present?
      "active"
    elsif index == 1 && params.keys.count { |p| p.include?("_page") } == 0
      "active"
    else
      ""
    end
  end

  def render_breadcrumbs(breadcrumbs)
    # https://bootstrapious.com/p/bootstrap-breadcrumbs
    return unless breadcrumbs
    content_tag(:nav, "aria-label": "breadcrumb") do
      content_tag(:ol, class: "breadcrumb breadcrumb-arrow p-0") do
        if breadcrumbs.length == 1
          last_breadcrumb(breadcrumbs.first)
        elsif breadcrumbs.length == 2
          safe_join([first_breadcrumb(breadcrumbs.first), last_breadcrumb(breadcrumbs.last)])
        else
          safe_join(
            [
              first_breadcrumb(breadcrumbs.first),
              middle_breadcrumbs(breadcrumbs[1...breadcrumbs.length - 1]),
              last_breadcrumb(breadcrumbs.last),
            ]
          )
        end
      end
    end
  end

  def client_initials(client_name)
    client_names = client_name.strip.split(/\s+/)

    "#{client_names.first[0]}#{client_names.last[0]}"
  end

  def badge_color(value)
    value ? "success".html_safe : "danger".html_safe
  end

  def status_tag(text, color)
    content_tag(:span, text, class: "badge badge-#{color}")
  end

  def filter(filter, wrapper_classes = "")
    content_tag(:div, class: wrapper_classes) do
      content_tag(:div, class: "form-group filter") do
        label_tag(filter[:name], filter[:label]) +
          select_tag(filter[:name], options_for_select(filter[:options], params[filter[:name]]),
            oncreate: "this.form.submit()", onchange: "this.form.submit()", class: "form-control")
      end
    end
  end

  def field_with_errors_class(resource, field, main_class = "form-control", error_class = "is-invalid")
    if resource.errors[field].present?
      "#{main_class} #{error_class}"
    else
      main_class.to_s
    end
  end

  private

  def last_breadcrumb(breadcrumb)
    content_tag(:li, breadcrumb[:text], "aria-current": "page",
      class: "breadcrumb-item pl-0 active text-uppercase pl-4")
  end

  def first_breadcrumb(breadcrumb)
    content_tag(:li, class: "breadcrumb-item") do
      content_tag(:a, breadcrumb[:text], { href: breadcrumb[:href], class: "text-uppercase pl-3" })
    end
  end

  def middle_breadcrumbs(breadcrumbs)
    middle_breadcrumbs = []
    breadcrumbs.each do |breadcrumb|
      middle_breadcrumbs <<
        content_tag(:li, class: "breadcrumb-item pl-0") do
          content_tag(:a, breadcrumb[:text], { href: breadcrumb[:href], class: "text-uppercase" })
        end
    end
    middle_breadcrumbs
  end
end
