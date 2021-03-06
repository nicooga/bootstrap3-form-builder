require 'bootstrap3-form-builder/helper_methods'

module Bootstrap3
  class FormBuilder < ActionView::Helpers::FormBuilder
    include Bootstrap3::HelperMethods
    include ActionView::Helpers::TagHelper

    [:text_field, :text_area, :number_field].each do |method_name|
      define_method method_name do |field, opts = {}|
        opts = merge_opts(opts, input_group: true) if opts[:addon]
        html = super(field, merge_opts(opts,
          placeholder: object.class.try(:human_attribute_name, field),
          class: 'form-control'
        ))
        input_wrapping html, opts
      end
    end

    def select(field, choices, opts = {}, html_opts = {})
      html = super field, choices, merge_opts(opts,
        input_group: true,
        include_blank: object.class.human_attribute_name(field)
      ), merge_opts(html_opts, class: 'form-control')
      input_wrapping html, opts
    end

    def datepicker(field, opts = {})
      html = text_field field
      input_wrapping html, merge_opts(opts,
        input_group: { class: 'datepicker date' },
        addon: ['#', :remove, :calendar],
        class: :date
      )
    end

    def datetimepicker(field, opts = {})
      html = text_field field
      opts = merge_opts(opts,
        input_group: { class: 'datetimepicker date' },
        addon: ['#', :remove, :calendar],
        class: :date
     )
     input_wrapping(html, opts)
    end

    def input_wrapping(html, opts = {})
      html = input_group_wrapping(html, opts)
    end

    def input_group_wrapping(html, opts = {})
      html = addon_rendering(html, opts[:addon])
      css_class = [opts[:input_group].try(:[], :class), 'input-group'].compact.join(' ')
      opts[:input_group] ? content_tag(:div, html, class: css_class) : html
    end

    def addon_rendering(html, opts = {})
      case opts
      when String, Symbol
        input_group_addon(opts) + html
      when Hash
        input_group_addon(opts[:before]) + html + input_group_addon(opts[:after])
      when Array
        opts.map do |icon_name|
          icon_name.to_s == '#' ? html : input_group_addon(icon_name)
        end.reduce(:+)
      else
        html
      end
    end

    def input_group_addon(opts)
      case opts
      when String, Symbol
        content_tag(:span, icon(opts), class: 'input-group-addon')
      when Hash
        css_class = [opts[:class], 'input-group-addon'].compact.join(' ')
        content_tag(:span, icon(opts[:icon_name]), class: css_class)
      end
    end

    def merge_opts(opts, defaults)
      defaults.merge(opts) do |k, old, new|
        k == :class ? [old.to_s, new.to_s].join(' ') : new
      end
    end

    def ignore_opts(opts, *keys)
      opts.dup.delete_if {|k| keys.include? k }
    end
  end
end
