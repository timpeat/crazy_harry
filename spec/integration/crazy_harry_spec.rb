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

  it "should not care about the chain order" do
    harry.fragment('<script>STEAL COOKIE!</script><em>Place</em><p>Lodging</p><b>Location:</b>')
      .translate!( from_text: 'Lodging', to_text: 'Hotel', add_attributes: { class: 'partner' } )
      .redact!( unsafe: true, tags: 'em' )
      .change!( from: 'b', to: 'h3' )
      .to_s.should == 'Place <p class="partner">Hotel</p><h3 class="partner">Location:</h3>'
  end

  it "should work on a real-world example" do
    bad_fragment        = File.read(File.expand_path('spec/fixtures/golden_nugget.html'))
    corrected_fragment  = File.read(File.expand_path('spec/fixtures/golden_nugget_corrected.html'))

    harry.fragment(bad_fragment)
      .redact!( unsafe: true )
      .change!( from: 'b', to: 'h3' )
      .change!( from: 'strong', to: 'h3')
      .to_s.should == corrected_fragment
  end

end
