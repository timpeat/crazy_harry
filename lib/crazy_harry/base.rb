module CrazyHarry
  class Base
    include CrazyHarry::Default
    include CrazyHarry::Change
    include CrazyHarry::Redact
    include CrazyHarry::Translate

    # TODO: Make everything callable/chainable from Base.
    
    attr_accessor :fragment, :scope, :steps, :text

    def initialize(opts = {})
      self.fragment = Loofah.fragment(opts.delete(:fragment)) if opts.has_key?(:fragment)
      self.steps = []
    end

    def to_s
      self.fragment.to_s.squeeze(' ').strip
    end

    private

    def run!
      steps.compact.each{ |step| fragment.scrub!(step) }
    end

    def alter_this_node?(node)
      ( self.text       ? node.text == self.text                          : true ) &&
      ( self.scope      ? node.parent.name == self.scope                  : true )
    end

  end
end
