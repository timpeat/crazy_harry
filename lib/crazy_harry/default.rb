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
      self.fragment = Loofah.fragment(html_with_duplicates_removed_from_the_bottom_up)
      self
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

    def html_with_duplicates_removed_from_the_bottom_up
      all_elements.reverse.delete_if{ |e| all_elements_less_current_element(e).include?(e) }.reverse.compact.join('')
    end

    def all_elements_less_current_element(element)
      remove = true

      all_elements_less_current_node = all_elements.delete_if do |e|
        if e == element && remove
          remove = false
          true
        end
      end
    end

    def all_elements
      @all_elements ||= self.fragment.children.map(&:to_html)
    end

  end
end
