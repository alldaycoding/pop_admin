module PopAdmin
  module GridIndex
    extend ActiveSupport::Concern

    def prepare_grid_records(model, options = {})
      options.reverse_merge!(count_scope: model)
      @records_count = options[:count_scope].count
      @records = model.all.offset(params[:start]).limit(params[:length])
      unless params[:order].blank?
        cols = params[:order].collect do |idx, ocol|
          "#{params['columns'][ocol[:column].to_s]['name']} #{ocol[:dir]}"
        end
        @records = @records.order(*cols) unless cols.blank?
      end
      @records = @records.decorate if options[:decorate]
    end

  end
end
