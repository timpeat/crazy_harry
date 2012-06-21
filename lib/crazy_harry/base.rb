module CrazyHarry
  class Base
    include CrazyHarry::Default
    include CrazyHarry::Change
    include CrazyHarry::Redact
    include CrazyHarry::Translate

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
      steps.compact.delete_if do |step|
        if steps.size > 0
          fragment.scrub!(step)
          true
        end
      end
    end

  end
end
