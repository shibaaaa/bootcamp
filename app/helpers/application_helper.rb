module ApplicationHelper
  def title(page_title)
    content_for(:title) {page_title}
    page_title
  end

  def page_slug
    controller.class.to_s.underscore.
      gsub(%r{/}, "-").
      gsub(/_controller/, "_") + action_name
  def li_for(record, prefix = nil, options = nil, &block)
    content_tag_for(:li, record, prefix, options, &block)
  end

  def tr_for(record, prefix = nil, options = nil, &block)
    content_tag_for(:tr, record, prefix, options, &block)
  end

  def my_practice?(practice)
    return false if current_user.blank?
    [:everyone, current_user.job].include?(practice.target)
  end
end
