# frozen_string_literal: true

module ApplicationHelper
  def link_to_add_fields(name = nil, f = nil, association = nil, options = nil, html_options = nil, &block)
    # If a block is provided there is no name attribute and the arguments are
    # shifted with one position to the left. This re-assigns those values.
    if block_given?
      html_options = options
      options = association
      association = f
      f = name
    end

    options = {} if options.nil?
    html_options = {} if html_options.nil?

    locals = if options.include? :locals
               options[:locals]
             else
               {}
             end

    partial = if options.include? :partial
                options[:partial]
              else
                association.to_s.singularize + '_fields'
              end

    # Render the form fields from a file with the association name provided
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, child_index: 'new_record') do |builder|
      render(partial, locals.merge!(f: builder))
    end

    # The rendered fields are sent with the link within the data-form-prepend attr
    html_options['data-form-prepend'] = raw CGI.escapeHTML(fields)
    html_options['href'] = '#'

    content_tag(:a, name, html_options, &block)
  end

  def flash_class(level)
    case level
    when 'notice' then 'alert alert-info'
    when 'success' then 'alert alert-success'
    when 'error' then 'alert alert-danger'
    when 'alert' then 'alert alert-warning'
    end
  end
end
