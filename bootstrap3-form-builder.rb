require 'action_view/helpers/form_helper.rb'

module Bootstrap3
  class FormBuilder < ActionView::Helpers::FormBuilder
    include ActionView::Helpers::TagHelper
    include ApplicationHelper

    [:text_field, :text_area, :number_field].each do |method_name|
      define_method method_name do |field, opts = {}|
        opts = merge_opts(opts, input_group: true) if opts[:addon]
      html = super(field, merge_opts(opts,
                                     placeholder: object.class.human_attribute_name(field),
                                     class: 'form-control'
                                    ))
                                    input_wrapping html, opts
      end
    end

    def select(field, choices, opts = {}, html_opts = {})
      html = super field, choices, merge_opts(opts,
                                              group: true,
                                              include_blank: object.class.human_attribute_name(field)
                                             ), merge_opts(html_opts, class: 'form-control')
                                             input_wrapping html, opts
    end

    def datepicker(field, opts = {})
      html = @template.content_tag(:div, class: 'form-group') do
        text_field field, opts.merge(class: :datepicker, addon: :calendar)
      end
      input_wrapping html, opts
    end

    def datetimepicker(field, opts = {})
      @field = field
      html = text_field field, merge_opts(opts, class: :datetimepicker)
      opts = merge_opts(opts,
                        input_group: { class: :datetimepicker },
                        addon: { before: { icon_name: :calendar, class: :datepickerbutton },
                                 after:  { icon_name: :remove, class: :date_remove } },
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
          icon_name.to_s == '#' ? html :
            input_group_addon(icon_name)
        end
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
