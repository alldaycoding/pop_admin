jQuery ->
  $.fn.pop_image_dropzone = () ->
    return this.each () ->
      html = """
        <div class='pop-dropzone-body {{style}}'>
          {{#if src}}
            <div class='pop-dropzone-img'><img src='{{src}}'></div>
          {{/if}}
        </div>
        <div class='pop-dropzone-title'>{{title}}
          <div class='pop-dropzone-opts {{style}}'>
            {{#if remove}}
              <a href="{{remove}}" class="pop-dropzone-remove entypo-trash"></a>
            {{/if}}
          </div>
        </div>
      """

      container = $(this)

      content =
        title: container.data('title')
        remove: container.data('remove')

      if $(this).data('src')
        content.src = container.data('src')
        content.style = ''
      else
        content.style = 'empty'

      template = Handlebars.compile(html)
      $(this).html(template(content))

      drop_el = '.pop-dropzone-body'

      container.find("#{drop_el} img").on 'click', () ->
        $(this).closest(drop_el).click()

      container.find(".pop-dropzone-remove").on 'click', (ev) ->
        ev.preventDefault()
        if !container.data('confirm')? || confirm(container.data('confirm'))
          $.ajax
            url: container.data('remove')
            method: 'DELETE'
          container.find(".pop-dropzone-img").remove()
          container.find(drop_el).addClass("empty")
          container.find('.pop-dropzone-opts').addClass("empty")
        return false

      $(this).find(drop_el).dropzone
        url: container.data('upload')
        headers:
          'X-CSRF-Token': $.rails.csrfToken()
        sending: (file, xhr, formData) ->
          container.find(".pop-dropzone-img").remove()
        success: (file, response) ->
          container.find(".dz-preview").remove()
          container.find(drop_el).html("<div class='pop-dropzone-img'><img src='#{response.url}'></div>")
          container.find(drop_el).removeClass("empty")
          container.find('.pop-dropzone-opts').removeClass("empty")
          container.find("#{drop_el} img").on 'click', () ->
            $(this).closest(drop_el).click()
