module PopAdmin
  module CrudActions
    extend ActiveSupport::Concern

    include GridIndex
    include Messages

    module ClassMethods

      def decorate(val)
        @decorate = val
      end

      def decorate?
        @decorate
      end

    end

    def index
    end

    def grid
      prepare_grid_records(scoped_model, decorate: self.class.decorate?)
    end

    def show
      set_resource
    end

    def new
      set_resource(resource_class.new)
    end

    def edit
      set_resource
    end

    def create
      set_resource(resource_class.new(resource_params))

      respond_to do |format|
        if get_resource.save
          format.html { redirect_to get_resource, notice: success_message(get_resource, :create) }
          format.json { render :show, status: :created, location: get_resource }
          format.js
        else
          flash[:alert] = error_message(get_resource, :create)
          format.html { render :new }
          format.json { render json: get_resource.errors, status: :unprocessable_entity }
          format.js
        end
      end
    end

    def update
      set_resource

      respond_to do |format|
        if get_resource.update(resource_params)
          format.html { redirect_to get_resource, notice: success_message(get_resource, :update) }
          format.json { render :show, status: :ok, location: get_resource }
          format.js
        else
          flash[:alert] = error_message(get_resource, :update)
          format.html { render :edit }
          format.json { render json: get_resource.errors, status: :unprocessable_entity }
          format.js
        end
      end
    end

    def destroy
      set_resource

      if get_resource.destroy
        respond_to do |format|
          format.html { redirect_to resources_index_path, notice: success_message(get_resource, :destroy) }
          format.json { head :no_content }
          format.js
        end
      else
        flash[:alert] = error_message(get_resource, :destroy)
        respond_to do |format|
          format.html { redirect_to get_resource }
          format.json { render json: get_resource.errors, status: :unprocessable_entity }
          format.js
        end
      end
    end

    private

    # Retorna el model filtrado
    # @return [Class] or [Object]
    def scoped_model
      resource_class
    end

    # Returns the resource from the created instance variable
    # @return [Object]
    def get_resource
      instance_variable_get("@#{resource_name}")
    end

    # The resource class based on the controller
    # @return [Class]
    def resource_class
      @resource_class ||= resource_name.classify.constantize
    end

    # The singular name for the resource class based on the controller
    # @return [String]
    def resource_name
      @resource_name ||= self.controller_name.singularize
    end

    # Only allow a trusted parameter "white list" through.
    # If a single resource is loaded for #create or #update,
    # then the controller for the resource must implement
    # the method "#{resource_name}_params" to limit permitted
    # parameters for the individual model.
    def resource_params
      @resource_params ||= self.send("#{resource_name}_params")
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_resource(resource = nil)
      resource ||= resource_class.find(params[:id])
      resource = resource.decorate if self.class.decorate?
      instance_variable_set("@#{resource_name}", resource)
    end

    def set_resource_count
      count = scoped_model.all.count
      instance_variable_set("@#{resource_name}_count", count)
    end

    def resources_index_path
      send("#{resource_name.pluralize}_path")
    end

  end
end
