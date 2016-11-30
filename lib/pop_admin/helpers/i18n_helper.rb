module PopAdmin::I18nHelper

  def enum_list(model, attribute)
    attr_key = attribute.to_s.pluralize.to_sym
    targets = model.send(attr_key).map do |k,v|
      [ta(model.model_name.to_s, "#{attr_key}.#{k}"), k]
    end
    Hash[*targets.flatten]
  end

  def translate_model_name(*options)
    I18n.tn(*options)
  end
  alias_method :tn, :translate_model_name

  def translate_model_attribute(*options)
    I18n.ta(*options)
  end
  alias_method :ta, :translate_model_attribute

  def translate_model_grid_index(*options)
    I18n.ti(*options)
  end
  alias_method :ti, :translate_model_grid_index

  def translate_boolean(*options)
    I18n.b(*options)
  end
  alias_method :b, :translate_boolean

  def translate_company_specific_text(text)
    I18n.tc(text)
  end
  alias_method :tc, :translate_company_specific_text

  def available_locales_options
    I18n.available_locales.collect { |l| [t("common.languages.#{l}"), l] }
  end

  def l(content, options = {})
    if content
      I18n.l(content, options)
    end
  end


end
