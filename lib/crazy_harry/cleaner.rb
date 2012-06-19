module CrazyHarry
  class Cleaner < Base

    BLOCK_CONVERSION_ELEMENTS = {
      inlines:  %w(br),
      blocks:   %w(div p)
    }

    attr_accessor :from, :to

    def clean!(opts)
      self.from  =  opts.delete(:from)
      self.to    =  opts.delete(:to)
      self.text  =  opts.delete(:text)
      self.scope =  opts.delete(:scope)

      self.steps << generic_from_to

      convert_inline_element_to_block!

      run!

      self
    end

    private

    def alter_this_node?(node)
      super(node) &&
      ( node.name == self.from )
    end

    def convert_inline_element_to_block?
      BLOCK_CONVERSION_ELEMENTS[:inlines].include?(self.from) &&
      BLOCK_CONVERSION_ELEMENTS[:blocks].include?(self.to)
    end

    def generic_from_to
      return if convert_inline_element_to_block?

      Loofah::Scrubber.new do |node|
        node.name = self.to if alter_this_node?(node)
      end
    end

    def convert_inline_element_to_block!
      return unless convert_inline_element_to_block?

      fragment.xpath("#{self.from}/following-sibling::text()|#{self.from}/preceding-sibling::text()").each do |node|
        node.replace(Nokogiri.make("<#{self.to}>#{node.to_html.strip}</#{self.to}>")) unless node.content =~ /\A\s*\z/
      end

      fragment.scrub!(scrub_tag(self.from))
    end

    def scrub_tag(tag_name)
      Loofah::Scrubber.new do |node|
        if node.name == tag_name
          node.remove
          Loofah::Scrubber::STOP # don't bother with the rest of the subtree
        end
      end
    end

  end
end
