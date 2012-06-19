require 'spec_helper'

describe CrazyHarry::Translator do

  #   Add attribute: "partner" to all tags
  #
  #   Another ADS suggestion.  Not sure it if it needed for the first cut.
  #   Transform "lodging" to "hotel"

  let(:translator) { CrazyHarry::Translator }

  it "should be able to add an attribute to all tags" do
    translator.new( fragment: '<b>a</b><br /><h3 class="red">c</h3>' ).translate( add_attributes: { class: 'from-partner'} ).run!.should ==
      '<b class="from-partner">a</b><br class="from-partner"><h3 class="red from-partner">c</h3>'
  end


end
