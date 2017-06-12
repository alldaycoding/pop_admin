module PopAdmin
  module Filterable
    extend ActiveSupport::Concern

    def filtered_scope(model_scope)
      if !params[:filters].blank?
        filtered_records_scope(model_scope)
      elsif self.respond_to?(:default_filters, true)
        default_filters(model_scope)
      else
        model_scope
      end
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
          when 'daterange'
            range = options[:value].split("..").map { |d| Time.parse(d) }
            res = res.where("#{filter}" => range[0]..range[1])
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
