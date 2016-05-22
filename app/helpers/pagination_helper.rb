module PaginationHelper
  START_PAGE = 1

  def draw_pagination(items_count, per_page)
    @pages_count = items_count / per_page + (items_count % per_page > 0 ? 1 : 0)
    @current_page = get_current_page

    next_page = get_next_page
    previous_page = get_previous_page

    if @pages_count > 1
      "<nav class=\"text-center\">
          <ul class=\"pagination\">
            #{draw_paginate_button :text => '<span aria-hidden="true">&laquo;</span>'.html_safe, :page => previous_page[:page], :disabled => previous_page[:disabled]}
            #{draw_pages}
            #{draw_paginate_button :text => '<span aria-hidden="true">&raquo;</span>'.html_safe, :page => next_page[:page], :disabled => next_page[:disabled]}
          </ul>
      </nav>".html_safe
    end
  end

  protected
  def get_current_page
    if params[:page].present? && params[:page].to_i > 0
       params[:page].to_i
    else
      START_PAGE
    end
  end

  protected
  def draw_pages
    html = ''
    (1..@pages_count).each do |i|
      html += draw_paginate_button :text => i, :page => i, :class => (i == @current_page ? 'active' : '')
    end
    html.html_safe
  end

  protected
  def draw_paginate_button args
    item_class = get_item_class(:class => args[:class], :disabled => args[:disabled])
    "<li class=\"#{item_class}\">#{link_to args[:text], get_pagination_url(args[:page])}</li>".html_safe
  end

  protected
  def get_item_class args
    item_class = args[:disabled] ? 'disabled' : ''
    item_class += args[:class].blank? ? '' : ' ' + args[:class]
  end

  protected
  def get_next_page
    result = {:disabled => true, :page => ''}
    if @current_page < @pages_count
      result = {:disabled => false, :page => @current_page + 1}
    end
    result
  end

  protected
  def get_previous_page
    result = {:disabled => true, :page => ''}
    if @current_page > START_PAGE
      result = {:disabled => false, :page => @current_page - 1}
    end
    result
  end

  protected
  def get_pagination_url page
    result = '#'
    unless page.blank?
      result = params.merge(:page => page)
    end
    result
  end
end