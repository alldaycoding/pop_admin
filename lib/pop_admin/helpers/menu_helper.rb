module PopAdmin::MenuHelper

  def menu_item(name, item)
    style = item[:children] ? 'has_sub' : ''
    content_tag 'li', class: style do
      menu_item_link(item) +
      menu_item_children(item)
    end
  end

  def menu_item_children(item)
    if item[:children]
      content_tag 'ul' do
        item[:children].map do |chname, chitem|
          menu_item(chname, chitem)
        end.join.html_safe
      end
    else
      ''.html_safe
    end
  end

  def menu_item_link(item)
    link_to(item[:url]) do
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

end
