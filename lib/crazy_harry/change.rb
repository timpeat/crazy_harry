module CrazyHarry
  module Change

    BLOCK_CONVERSION_ELEMENTS = {
      inlines:  %w(br),
      blocks:   %w(div p)
    }

    attr_accessor :from, :to

    def change!(opts)
      self.from  =  opts.delete(:from)
      self.to    =  opts.delete(:to)
      self.text  =  opts.delete(:text)
      self.scope =  opts.delete(:scope)

      self.steps << generic_from_to
      self.steps << unwrap_unnecessary_paragraphs

      run!

      self
    end

    private

    def change_this_node?(node)
      ( self.text       ? node.text == self.text                          : true ) &&
      ( self.scope      ? node.parent.name == self.scope                  : true ) &&
      ( node.name == self.from )
    end

    def convert_inline_element_to_block?
      BLOCK_CONVERSION_ELEMENTS[:inlines].include?(self.from) &&
      BLOCK_CONVERSION_ELEMENTS[:blocks].include?(self.to)
    end

    def generic_from_to
      return if convert_inline_element_to_block?

      Loofah::Scrubber.new do |node|
        node.name = self.to if change_this_node?(node)
      end
    end

    def unwrap_unnecessary_paragraphs
      Loofah::Scrubber.new do |node|
        node.replace(node.children.first) if unnecessary_paragraph?(node)
      end
    end

    def unnecessary_paragraph?(node)
      node.name == 'p' &&
      node.children.size == 1 &&
      Loofah::Elements::BLOCK_LEVEL.include?(node.children.first.name)
    end

  end
end
