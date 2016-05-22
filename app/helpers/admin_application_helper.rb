module AdminApplicationHelper
  def get_sort_buttons link_asc, link_desc
    "<div class=\"sorting-wrapper\">
      #{link_to '', link_asc, class: "sort-arrow asc-arrow"}
      #{link_to '', link_desc, class: "sort-arrow dsc-arrow"}
    </div>".html_safe
  end
end
