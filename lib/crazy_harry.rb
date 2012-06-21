require 'loofah'

%w(default base cleaner redactor translator version).each do |load_lib|
  require_relative "crazy_harry/#{load_lib}"
end

module CrazyHarry

  attr_accessor :harry

  class << self

    def fragment(fragment)
      harry = Base.new(fragment: fragment)
      harry.no_blanks!
      harry.dedupe!
      harry
    end

    def to_s
      @harry.to_s
    end

  end

end
