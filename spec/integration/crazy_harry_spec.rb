require 'spec_helper'

describe CrazyHarry do

  let(:harry) { CrazyHarry }

  it "should allow method chaining" do
    harry.fragment('<script>STEAL COOKIE!</script><em>Place</em><p>Lodging</p><b>Location:</b>')
      .redact!( unsafe: true, tags: 'em' )
      .change!( from: 'b', to: 'h3' )
      .translate!( from_text: 'Lodging', to_text: 'Hotel', add_attributes: { class: 'partner' } )
      .to_s.should == 'Place <p class="partner">Hotel</p><h3 class="partner">Location:</h3>'
  end

end
