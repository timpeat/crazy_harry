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

    private

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
