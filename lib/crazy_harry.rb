require 'loofah'

%w(default change redact translate base version).each do |load_lib|
  require_relative "crazy_harry/#{load_lib}"
end

module CrazyHarry

  attr_accessor :base

  class << self

    def fragment(fragment, opts = {})
      no_br_changes = opts.delete(:no_br_changes)
      base = Base.new(fragment: fragment)
      base.no_blanks!
      base.convert_br_to_p! unless no_br_changes
      base.dedupe!
      base
    end

    def to_s
      @base.to_s
    end

  end

end
