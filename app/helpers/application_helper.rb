module ApplicationHelper

  # nav_links
  def nav_link(link_text, link_path)
    class_name = current_page?(link_path) ? 'current' : ''

    content_tag(:li, :class => class_name) do
      link_to link_text, link_path
    end
  end


  def uniq_words(*args)
      args[0].where(counter: 1).where('syllable > 1')
  end

  # active links for nav
  def active_class(link_path)
    current_page?(link_path) ? "active" : ""
  end

  # page title
    def title(page_title)
        content_for(:title) { page_title }
    end

  def markdown(text)
        options = {
          filter_html:     true,
          hard_wrap:       true,
          link_attributes: { rel: 'nofollow', target: "_blank" },
          space_after_headers: true,
          fenced_code_blocks: true
        }

        extensions = {
          autolink:           true,
          superscript:        true,
          disable_indented_code_blocks: true
        }

        renderer = Redcarpet::Render::HTML.new(options)
        markdown = Redcarpet::Markdown.new(renderer, extensions)

        markdown.render(text).html_safe
  end

end
