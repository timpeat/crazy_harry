module CrazyHarry
  module Redact

    class InvalidStripMethod < StandardError; end;

    STRIP_METHODS =  %w(strip prune escape whitewash)

    attr_accessor :attributes, :tags, :unsafe

    def strip!
      fragment.to_text
    end

    def redact!(opts = {})
      self.unsafe       = opts.delete(:unsafe) || opts == {}
      self.tags         = [opts.delete(:tags)].compact.flatten
      self.attributes   = opts.delete(:attributes)
      self.text         = opts.delete(:text)
      self.scope        = opts.delete(:scope)
      prune             = opts.delete(:prune)

      self.steps << strip_unsafe  if self.unsafe
      self.steps << strip_tags    unless prune || self.tags == []
      self.steps << prune_tags    if prune

      run!

      self
    end

    private

    def redact_this_node?(node)
      ( self.text       ? node.text == self.text                          : true ) &&
      ( self.scope      ? node.parent.name == self.scope                  : true ) &&
      ( self.attributes ? self.attributes.any?{ |a,v| node[a.to_s] == v } : true ) &&
      self.tags.include?(node.name)
    end

    def strip_unsafe
      fail InvalidStripMethod, "vaild methods are #{STRIP_METHODS.join(', ')}." unless valid_strip_method?

      STRIP_METHODS.include?(self.unsafe.to_s) ? self.unsafe.to_sym : :prune
    end

    def valid_strip_method?
      return true if self.unsafe == true || STRIP_METHODS.include?(self.unsafe.to_s)
    end

    def strip_tags
      Loofah::Scrubber.new do |node|
        content = block_node?(node) ? "#{node.content}\n" : "#{node.content} "
        node.replace(content) if redact_this_node?(node)
      end
    end

    def block_node?(node)
      Loofah::Elements::BLOCK_LEVEL.include?(node.name)
    end

    # TODO: Refactor and DRY out--nearly identical to
    # ::Default#scrub_tag
    def prune_tags
      Loofah::Scrubber.new do |node|
        if redact_this_node?(node)
          node.remove
          Loofah::Scrubber::STOP # don't bother with the rest of the subtree
        end
      end
    end
    
  end
end
