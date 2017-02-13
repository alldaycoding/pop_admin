pop_admin_helpers = [
  :i18n_helper, :content_helper, :datatable_helper, :form_helper,
  :header_helper, :menu_helper, :modal_helper, :ujs_helper
]

pop_admin_helpers.each do |helper|
  require "pop_admin/helpers/#{helper}"
  ActionView::Base.send :include, "PopAdmin::#{helper.to_s.classify}".constantize
end
