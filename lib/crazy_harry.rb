require 'loofah'

%w(default change redact base translator version).each do |load_lib|
  require_relative "crazy_harry/#{load_lib}"
end

module CrazyHarry

  attr_accessor :base

  class << self

    def fragment(fragment)
      base = Base.new(fragment: fragment)
      base.no_blanks!
      base.convert_br_to_p!
      base.dedupe!
      base
    end

    def to_s
      @base.to_s
    end

  end

end
