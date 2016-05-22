class Employees::EmployeesApplicationController < ApplicationController

  layout 'application_employee'
  PAGINATION_PER_PAGE = 3

  def paginate collection, page, per_page
    current_page = self.get_validated_page(page.to_i)
    collection.limit(per_page).offset(current_page * per_page)
  end

  protected
  def get_validated_page page
    page > 0 ? page - 1 : 0
  end
end
