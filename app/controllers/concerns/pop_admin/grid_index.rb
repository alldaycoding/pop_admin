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

      if params[:filters]
        @records = filtered_records_scope(@records)
      elsif self.respond_to?(:default_filters, true)
        @records = default_filters(@records)
      end

      @records = @records.decorate if options[:decorate]
    end

    def filtered_records_scope(curr_scope)
      res = curr_scope
      params[:filters].each do |filter, options|
        unless options[:value].blank?
          case options[:type].to_s
          when 'bool'
            val = [1, true, "1", "true"].include?(options[:value])
            res = res.where(filter => val)
          when 'contain'
            res = res.where("#{filter} LIKE ?", "%#{options[:value]}%")
          when 'custom'
            res = self.custom_filter(res, field, options[:value])
          else
            res = res.where(filter => options[:value])
          end
        end
      end
      res
    end

  end
end
