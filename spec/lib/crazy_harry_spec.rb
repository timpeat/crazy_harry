require 'spec_helper'

describe CrazyHarry do

  let(:harry){ CrazyHarry }

  it "should be able to de-dupe content at the block element level" do
    harry.fragment('<p>Duplicate.</p><p>Duplicate</p>').dedupe!.to_s.should == '<p>Duplicate.</p>'
  end


end
