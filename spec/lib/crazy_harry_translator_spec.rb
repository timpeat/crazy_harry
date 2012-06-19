require 'spec_helper'

describe CrazyHarry::Translator do

  #   Add attribute: "partner" to all tags
  #
  #   Another ADS suggestion.  Not sure it if it needed for the first cut.
  #   Transform "lodging" to "hotel"

  let(:translator) { CrazyHarry::Translator }

  it "should be able to add an attribute to all tags" do
    translator.new( fragment: '<b>a</b><br /><h3>c</h3>' ).translate( add_attributes: { class: 'from-partner'} ).run!.should ==
      '<b class="from-partner">a</b><br class="from-partner"><h3 class="from-partner">c</h3>'
  end

  it "should be able to add multiple attributes to all tags" do
    translator.new( fragment: '<b>a</b><br /><h3>c</h3>' ).translate( add_attributes: { class: 'boo', bubba: 'beau' } ).run!.should ==
      '<b class="boo" bubba="beau">a</b><br class="boo" bubba="beau"><h3 class="boo" bubba="beau">c</h3>'
  end

  it "should append information to existing attributes" do
    translator.new( fragment: '<h3 class="red">Lorem</h3>' ).translate( add_attributes: { class: 'from-partner'} ).run!.should ==
      '<h3 class="red from-partner">Lorem</h3>'
  end

  it "should be able to tranlate free text in the fragment, preservering case" do
    translator.new( fragment: '<h3>Lodging</h3> lodging' ).translate( from_text: 'lodging', to_text: 'hotel' ).run!.should ==
      '<h3>Hotel</h3> hotel'
  end


end
