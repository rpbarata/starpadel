# frozen_string_literal: true

class CheckBox < Trestle::Form::Field
  def initialize(builder, template, name, options = {}, &block)
    super
    @builder = builder
    @template = template
    @name = name
    @options = options
    @block = block
  end

  def render
    content_tag(:div, class: wrapper_class) do
      concat(field)
      concat(error_messages) if name && errors.any?
    end
  end

  private

  def wrapper_class
    name && errors.any? ? "form-group has-error" : "form-group"
  end

  def label_class
    name && errors.any? ? "custom-control-label is-invalid" : "custom-control-label"
  end

  def field
    content_tag(:div, class: "custom-control #{switch? ? "custom-switch" : "custom-checkbox"}") do
      safe_join([
        builder.raw_check_box(name, options.merge(class: "custom-control-input")),
        builder.label(name, options[:label] || admin.human_attribute_name(name), class: label_class),
      ])
    end
  end

  def error_messages
    content_tag(:ul, class: "invalid-feedback") do
      safe_join(errors.map do |error|
        content_tag(:li, safe_join([icon("fa fa-warning"), error], " "))
      end, "\n")
    end
  end

  def errors
    error_keys.map { |key| builder.errors(key) }.flatten
  end

  def switch?
    options[:switch]
  end
end
