module PopAdmin::DatatableHelper

  def datatable(options = {})
    options.reverse_merge!(
      class: "table condensed table-striped table-hover responsive datatable",
      id: "table_#{params[:controller]}_#{params[:action]}",
      columns: [],
      rows_group: [],
      order: [[0, 'asc']],
      columnDefs: [],
      data: {}
    )

    options[:url] ||= send(
      "grid_#{controller.class.name.gsub("Controller", "").underscore}_path",
      { format: :json }
    )

    if options[:remote]
      options[:data][:remote] = true
    end

    options[:i18n_url] ||= asset_path("datatables/i18n/#{I18n.locale}.json")

    res = []
    res << content_tag('table', class: options[:class], id: options[:id], width: '100%',
      data: options[:data]) do
      content_tag('thead') do
        content_tag('tr') do
          options[:columns].collect do |name, col_options|
            col_options[:title] ||= name
            content_tag('th', col_options[:title], data: { hide: name, name: name })
          end.join().html_safe
        end
      end
    end

    column_defaults = { className: '', orderable: true }

    columns_js = options[:columns].collect do |col, opts|
      col_name = opts[:column_name] || col
      opts.reverse_merge!(column_defaults)
      { data: col, name: col_name, className: opts[:class_name],
        orderable: opts[:orderable] }
    end

    res << javascript_tag(type: "text/javascript") do
      %Q[
        $(document).ready(function() {
          var tbl = new Pop.Table("##{options[:id]}");
          tbl.render({ url: "#{options[:url]}",
            columns: #{raw(columns_js.to_json)},
            i18n_url: "#{options[:i18n_url]}",
            order: #{raw(options[:order].to_json)},
            rows_group: #{raw(options[:rows_group].to_json)},
            authenticity_token: "#{form_authenticity_token}" });
        });
      ].html_safe
    end

    res.join().html_safe
  end

end
