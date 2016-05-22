module ApplicationHelper

  def form_number_field(form_builder, field_name)
    result = "#{form_builder.label(field_name, class: 'col-md-1 control-label')}"
    result += "<div class='col-md-2'>"
    result += "#{form_builder.number_field(field_name)}</div>"
    result.html_safe
  end

  def form_select_field(form_builder, field_name, fill_data, id_field, values_field, options)
    result = "#{form_builder.label(field_name, class: 'col-md-1 control-label')}"
    result += "<div class='col-md-4'>"
    result += "#{form_builder.collection_select(field_name,fill_data,id_field,values_field, options)}</div>"

    result.html_safe
  end

  def form_simple_select_field(form_builder,label_for,obj_name, field_name, fill_data)
    result = "#{form_builder.label(label_for, class: 'col-md-1 control-label')}"
    result += "<div class='col-md-4'>"
    result += "#{form_builder.select(obj_name,field_name, fill_data,{},{class:'col-md-1 control-label'})}</div>"

    result.html_safe
  end

  def form_field_text (form_builder, field_name)
    "<div class='field form-group'> #{form_builder.label(field_name)}<div class='col-sm-10'> #{form_builder.text_field(field_name)} </div></div>".html_safe
  end

  def form_field_row_numeric (form_builder, field_name)
    "#{form_builder.label field_name, class: 'col-md-2 control-label'} <div class='col-md-2'> #{form_builder.number_field(field_name)} </div>".html_safe
  end

  def form_field_row_collection_select (form_builder, field_name, method, collection, value_method, text_method, options = {}, html_options = {})
    "#{form_builder.label field_name, class: 'col-md-2 control-label'} <div class='col-md-2'> #{form_builder.collection_select(method, collection, value_method, text_method, options, html_options)} </div>".html_safe
  end

  def form_field_row_select (form_builder, field_name, method, choices = nil, options = {}, html_options = {}, &block)
    "#{form_builder.label field_name, class: 'col-md-2 control-label'} <div class='col-md-2'> #{form_builder.select(method, choices, options, html_options)} </div>".html_safe
  end

  def page_header (title, subtitle = '')
    "<div class='page-header'><h1>#{title}<small>#{subtitle}</small></h1></div>".html_safe
  end


end
