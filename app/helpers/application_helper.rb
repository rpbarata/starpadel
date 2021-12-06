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

  def export_clients_params(params)
    export_params = params.permit!.slice(:q, :scope)

    export_params.to_query
  end
end
