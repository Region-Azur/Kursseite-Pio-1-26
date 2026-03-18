# frozen_string_literal: true

module Jekyll
  class SidebarTabsGenerator < Generator
    safe true
    priority :low

    def generate(site)
      tabs = site.collections['tabs']
      return unless tabs

      generated = {}

      site.pages.each do |page|
        next unless page.data['sidebar']
        next unless page.url

        title = (page.data['sidebar_title'] || page.data['title'] || '').strip
        next if title.empty?

        icon = (page.data['sidebar_icon'] || '').strip
        order = page.data['sidebar_order']
        slug = page.data['slug'] || File.basename(page.path, File.extname(page.path))
        slug = slug.to_s.downcase.gsub(/[^a-z0-9_-]+/, '-').gsub(/-+/, '-').gsub(/A-+|-+z/, '')
        slug = 'page' if slug.empty?

        tab_path = File.join(site.source, '_tabs', '_generated', "#{slug}.md")
        next if generated[tab_path]
        generated[tab_path] = true

        doc = Jekyll::Document.new(tab_path, { site: site, collection: tabs })
        doc.content = ''
        doc.data['layout'] = 'page'
        doc.data['title'] = title
        doc.data['icon'] = icon unless icon.empty?
        doc.data['order'] = order if order
        doc.data['permalink'] = page.url
        doc.data['published'] = false

        tabs.docs << doc
      end
    end
  end
end
