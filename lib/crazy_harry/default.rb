module CrazyHarry
  module Default
    TARGET_ELEMENTS = ['b'].to_set 
    TARGET_ELEMENTS.merge(Loofah::Elements::BLOCK_LEVEL)

    def no_blanks! 
      self.steps << remove_blank_elements
      run!
      self
    end

    def dedupe!
      deduped_html_set = self.fragment.children.map(&:to_html).to_set

      self.fragment = Loofah.fragment(deduped_html_set.to_a.join(''))
    end

    def convert_br_to_p!
      fragment.xpath('br/following-sibling::text()|br/preceding-sibling::text()').each do |node|
        node.replace(Nokogiri.make("<p>#{node.to_html.strip}</p>")) unless node.content =~ /\A\s*\z/
      end

      fragment.scrub!(scrub_tag('br'))
    end

    private

    def scrub_tag(tag_name)
      Loofah::Scrubber.new do |node|
        if node.name == tag_name
          node.remove
          Loofah::Scrubber::STOP # don't bother with the rest of the subtree
        end
      end
    end

    def this_element?(element)
      name = element.respond_to?(:name) ? element.name : element
      TARGET_ELEMENTS.include?(name) 
    end

    def remove_blank_elements
      Loofah::Scrubber.new do |node|
        node.remove if this_element?(node) && node.content.empty?
      end
    end

  end
end
