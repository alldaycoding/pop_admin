module PopAdmin::UjsHelper

  def trigger_ujs_event(object)
    success = object.errors.empty?
    raw %Q{
      $("body").trigger("ujs.#{controller_name}.#{action_name}", [#{object.to_json}, #{success}, #{object.errors.to_json}]);
    }
  end

end
