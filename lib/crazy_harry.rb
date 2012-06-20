require 'loofah'
Dir[File.expand_path("lib/crazy_harry/**/*.rb")].each {|f| require f}

module CrazyHarry

  def self.fragment(fragment)
    Base.new(fragment: fragment)  
  end

end
