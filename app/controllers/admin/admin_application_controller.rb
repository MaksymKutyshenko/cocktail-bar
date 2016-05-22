class Admin::AdminApplicationController < ApplicationController
  include Admin::SessionsHelper
  layout 'application_admin'
  PAGINATION_PER_PAGE = 5

  def paginate collection, page, per_page
    current_page = self.get_validated_page(page.to_i)
    if collection.kind_of? Array
      collection.slice!(current_page * per_page, per_page) #TODO: CHANGE THIS
    else
      collection.limit(per_page).offset(current_page * per_page)
    end
  end

  protected
  def get_validated_page page
    page > 0 ? page - 1 : 0
  end
end
