require 'spec_helper'

describe CrazyHarry::Cleaner do

  #   Change br to p
  #   Change br to p where br has count: "(1|2|3|multiple)"
  #   Change p to linebreaks
  #   Change br to linebreaks
  #   Change multiple br to linebreaks
  #   Change b to h3 where b has text: "location"
  #   Change b to em where b inside p

  context "change" do

    it "should change one tag to another" do
      CrazyHarry::Cleaner.new( fragment: '<b>Location:</b>' ).change( from: 'b', to: 'h3' ).run!.should == '<h3>Location:</h3>'
    end

    it "should change an isolated tag to a wrapping tag" do
      CrazyHarry::Cleaner.new( fragment: 'Hotel Details<br />' ).change( from: 'br', to: 'p' ).run!.should == '<p>Hotel Details</p>'
    end

    it "spec_name" do
      
    end

  end

end
