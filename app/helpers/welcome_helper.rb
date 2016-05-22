module WelcomeHelper

  def set_current_table_id(table_id)
    cookies.permanent[:table_id] = table_id
  end

  def get_current_table_id
    @current_table_id||=cookies[:table_id]
  end

end
