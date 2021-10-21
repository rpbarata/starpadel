# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def translate(enum)
    if self[enum].present?
      I18n.t("activerecord.enums.#{enum}_list.#{self[enum]}")
    else
      ""
    end
  end
end
