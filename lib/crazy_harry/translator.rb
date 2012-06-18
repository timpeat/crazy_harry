module CrazyHarry
  class Translator

    attr_accessor :fragment, :text, :scope, :steps,
      :add_attributes

    def initialize(opts = {})
      self.fragment = Loofah.fragment(opts.delete(:fragment)) if opts.has_key?(:fragment)
      self.steps = []
    end

    def translate(opts = {})
      self.add_attributes   = opts.delete(:add_attributes)

      self.steps << change_attributes

      self
    end

    def run!
      steps.compact.each{ |step| fragment.scrub!(step) }
      fragment.to_s.squeeze(' ').strip
    end

    private

    def change_attributes
      Loofah::Scrubber.new do |node|
        self.add_attributes.map do |k,v|
          node_key = k.to_s

          node[node_key] = [node[node_key], v].compact.join(' ')
        end
      end
    end

  end
end
