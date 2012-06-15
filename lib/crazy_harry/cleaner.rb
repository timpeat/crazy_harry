require 'loofah'

module CrazyHarry
  class Cleaner

    attr_accessor :fragment, :from, :to, :steps

    def initialize(opts = {})
      self.fragment = Loofah.fragment(opts.delete(:fragment)) if opts.has_key?(:fragment)
      self.steps = []
    end

    def change(opts)
      self.from  =  opts.delete(:from)
      self.to    =  opts.delete(:to)
      self.steps << generic_from_to
      self
    end

    def run!
      steps.each{ |step| fragment.scrub!(step) }
      fragment.to_s
    end

    private

    def generic_from_to
      Loofah::Scrubber.new do |node|
        node.name = self.to if node.name == self.from
      end
    end

    def scrub_img
      Loofah::Scrubber.new do |node|
        if node.name == "img"
          node.remove
          Loofah::Scrubber::STOP # don't bother with the rest of the subtree
        end
      end
    end

  end
end
