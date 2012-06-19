module CrazyHarry
  class Base

    attr_accessor :fragment, :scope, :steps, :text

    def initialize(opts = {})
      self.fragment = Loofah.fragment(opts.delete(:fragment)) if opts.has_key?(:fragment)
      self.steps = []
    end

    def run!
      steps.compact.each{ |step| fragment.scrub!(step) }
    end

    def to_s
      self.fragment.to_s.squeeze(' ').strip
    end

    private

    def alter_this_node?(node)
      ( self.text       ? node.text == self.text                          : true ) &&
      ( self.scope      ? node.parent.name == self.scope                  : true )
    end

  end
end
