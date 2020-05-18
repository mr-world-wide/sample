module ApplicationHelper
  def full_title(page_title = '')
    base_title = "Daoboard: The roundabout way to getting things done"
    if page_title.blank?
      base_title
    else
      page_title + " | " + base_title
    end
  end
end
