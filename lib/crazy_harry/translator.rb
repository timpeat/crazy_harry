module CrazyHarry
  class Translator < Base

    attr_accessor :add_attributes, :from_text, :to_text

    def translate!(opts = {})
      self.add_attributes   = opts.delete(:add_attributes)
      self.from_text        = opts.delete(:from_text)
      self.to_text          = opts.delete(:to_text)
      self.text             = opts.delete(:text)
      self.scope            = opts.delete(:scope)

      self.steps << change_attributes if self.add_attributes
      self.steps << change_text if change_text?

      run!

      self
    end

    private

    def alter_this_node?(node)
     super(node) &&
     true
    end

    def change_text?
      self.from_text && self.to_text
    end

    def change_attributes
      Loofah::Scrubber.new do |node|
        if alter_this_node?(node)
          self.add_attributes.map do |k,v|
            node_key = k.to_s

            node[node_key] = [node[node_key], v].compact.join(' ')
          end
        end
      end
    end

    def change_text
      Loofah::Scrubber.new do |node|
        capitalized_from = self.from_text.capitalize
        capitalized_to   = self.to_text.capitalize

        node.content = node.content.gsub(/#{self.from_text.downcase}/, self.to_text.downcase) if node.content[/#{self.from_text.downcase}/]
        node.content = node.content.gsub(/#{capitalized_from}/, capitalized_to) if node.content[/#{capitalized_from}/]
      end
    end

  end
end
