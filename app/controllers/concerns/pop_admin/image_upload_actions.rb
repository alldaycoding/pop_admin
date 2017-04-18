module PopAdmin
  module ImageUploadActions
    extend ActiveSupport::Concern

      def upload_image
        resource_name ||= self.controller_name.singularize
        resource_class ||= resource_name.classify.constantize

        @resource = resource_class.find(params[:id])
        @resource.send("#{params[:image_type]}=", params[:file])
        @resource.save!

        render json: { url: @resource.send(params[:image_type].to_sym).url }
      end

      def remove_image
        resource_name ||= self.controller_name.singularize
        resource_class ||= resource_name.classify.constantize

        @resource = resource_class.find(params[:id])
        @resource.send("#{params[:image_type]}=", nil)
        @resource.save!

        render nothing: true
      end

  end
end
