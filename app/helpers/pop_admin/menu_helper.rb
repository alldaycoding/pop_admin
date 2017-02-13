module PopAdmin::MenuHelper

  def render_menu
    @menu_items = {}
    load_menu_config if defined?(Rails)

    items = @menu_items.collect do |name, item|
      menu_item(name, item)
    end

    content_tag 'ul', id: "main-menu", class: "main-menu" do
      items.join.html_safe
    end

  end

  def load_menu_config
    if defined?(Rails)
      path = Rails.root.join("config", "menu.rb")
      if File.exists?(path)
        instance_eval File.read(path), path.to_s
      end
    end
  end

  def menu_item(name, item)
    if item[:visible]
      style = (item[:items] && item[:items].any?) ? 'has_sub' : ''
      content_tag 'li', class: style do
        menu_item_link(name, item) +
        menu_item_children(item)
      end
    end
  end

  def menu_item_children(item)
    if item[:items]
      content_tag 'ul' do
        item[:items].map do |chname, chitem|
          menu_item(chname, chitem)
        end.join.html_safe
      end
    else
      ''.html_safe
    end
  end

  def menu_item_link(name, item)
    link_opts = item.slice(:method, :remote)
    unless item[:label]
      item[:label] = t("menu.#{name}", default: tn(name))
    end
    link_to(item[:url], link_opts) do
      menu_item_icon(item) +
      content_tag('span', item[:label], class: 'title')
    end
  end

  def menu_item_icon(item)
    if item[:icon]
      content_tag('i', '', class: item[:icon])
    else
      ''.html_safe
    end
  end

  private

  def menu_model(model, options = {})
    name = ActiveModel::Naming.plural(model)
    options.reverse_merge!(url: send("#{name}_path"), visible: can?(:read, model))
    menu(name.to_sym, options)
  end

  def menu(name, options = {})
    options.reverse_merge!(visible: true)

    if @current_menu_parent
      @current_menu_parent[:items] ||= {}
      item = @current_menu_parent[:items][name] = options
    else
      item = @menu_items[name] = options
    end

    if block_given?
      old_parent = @current_menu_parent
      @current_menu_parent = item
      yield
      @current_menu_parent = old_parent
    end

    if item[:items]
      vis = item[:items].collect { |k, v| v[:visible] }
      if item[:items].empty? || !vis.reduce(:|)
        item[:visible] = false
      end
    end
  end

end
