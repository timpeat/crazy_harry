require 'spec_helper'

describe CrazyHarry::Cleaner do

  #   Change br to p
  #   Change b to h3 where b has text: "location"
  #   Change b to em where b inside p
  #
  #   Add attribute: "partner" to all tags
  #
  #   Another ADS suggestion.  Not sure it if it needed for the first cut.
  #   Transform "lodging" to "hotel"

  context "change" do

    let(:cleaner){ CrazyHarry::Cleaner }

    it "should be able to change one tag to another" do
      cleaner.new( fragment: '<b>Location:</b>' ).clean!( from: 'b', to: 'h3' ).to_s.should == '<h3>Location:</h3>'
    end

    context "chaining" do

       it "should be able to chain calls" do
        cleaner.new( fragment: '<b>Location:</b><br />Saigon' ).clean!( from: 'b', to: 'h3').clean!( from: 'br', to: 'p' ).to_s.should ==
          '<h3>Location:</h3><p>Saigon</p>'
      end

      it "should not care about the order of the chain" do
        cleaner.new( fragment: '<b>Location:</b><br />Saigon' ).clean!( from: 'br', to: 'p' ).clean!( from: 'b', to: 'h3' ).to_s.should ==
          '<h3>Location:</h3><p>Saigon</p>'
      end

    end

    it "should be able to change all the tags it finds" do
      cleaner.new( fragment: '<b>1</b>, <b>2</b>, <b>3</b>' ).clean!( from: 'b', to: 'h3' ).to_s.should == '<h3>1</h3>, <h3>2</h3>, <h3>3</h3>'
    end

    it "should be able to change a span tag to a div" do
      cleaner.new( fragment: '<span>Hotel Details</span>' ).clean!( from: 'span', to: 'div' ).to_s.should == '<div>Hotel Details</div>'
    end

    it "should not change things that it isn't directed to" do
      cleaner.new( fragment: '<h3>Hotel Details</h3>' ).clean!( from: 'span', to: 'div' ).to_s.should == '<h3>Hotel Details</h3>'
    end

    it "shouldn't choke if it gets invalid tags" do
      cleaner.new( fragment: '<h3>Hotel Details</h3>' ).clean!( from: 'snoogenflozen', to: 'snarglebat' ).to_s.should == '<h3>Hotel Details</h3>'
    end

    context "targeting and scoping" do

      it "should change all occurrences" do
       cleaner.new( fragment: '<div><b>Hotels</b></div><p><b>Hotels</b></p><b>Tents</b><div><p><b>Campervan</b></p></div>' ).clean!( from: 'b', to: 'em').to_s.should ==
          '<div><em>Hotels</em></div><p><em>Hotels</em></p><em>Tents</em><div><p><em>Campervan</em></p></div>'
      end

      it "should be able to target changes by content" do
        cleaner.new( fragment: 'Hot <b>hotels</b> in <b>Saigon</b>' ).clean!( from: 'b', to: 'em', text: 'hotels' ).to_s.should ==
          'Hot <em>hotels</em> in <b>Saigon</b>'
      end

      it "should be able to scope changes to specific blocks" do
        cleaner.new( fragment: '<div><b>Hotels</b></div><p><b>Hotels</b></p><b>Tents</b>' ).clean!( from: 'b', to: 'em', scope: 'p' ).to_s.should ==
          '<div><b>Hotels</b></div><p><em>Hotels</em></p><b>Tents</b>'
      end

    end

    context "inline tags to blocks" do

      it "should be able to change an isolated br to a p" do
        cleaner.new( fragment: 'Hotel Details<br />' ).clean!( from: 'br', to: 'p' ).to_s.should == '<p>Hotel Details</p>'
      end

      it "should be able to change multiple br tags to a single p" do
        cleaner.new( fragment: 'Hotel Details<br /><br /><br />' ).clean!( from: 'br', to: 'p' ).to_s.should == '<p>Hotel Details</p>'
      end

      it "should clear unnecessary whitespace when converting line-style to block-style" do
         cleaner.new( fragment: 'hotel<br />        hostel      <br />').clean!( from: 'br', to: 'p').to_s.should ==
          '<p>hotel</p><p>hostel</p>'
      end

      it "should be able to change all br tags to wrapped p tags" do
        cleaner.new( fragment: 'hotel<br /> hostel<br /> tent<br />').clean!( from: 'br', to: 'p').to_s.should ==
          '<p>hotel</p><p>hostel</p><p>tent</p>'
      end

      it "should be able to change all multiple br tags to wrapped tags" do
        cleaner.new( fragment: 'hotel<br /><br /><br/> hostel<br /> tent<br />').clean!( from: 'br', to: 'p').to_s.should ==
          '<p>hotel</p><p>hostel</p><p>tent</p>'
      end

      it "should be able to convert leading inline tags to block tags" do
        cleaner.new( fragment: '<br /><br />hotel').clean!( from: 'br', to: 'p').to_s.should == '<p>hotel</p>'
      end

      it "should ignore stray inline tags if they don't appear relevant to the context" do
        cleaner.new( fragment: '<br /><br />hotel <br />hostel<br />').clean!( from: 'br', to: 'p').to_s.should == '<p>hotel</p><p>hostel</p>'
      end

      it "should be able to change a br tag to a div" do
        cleaner.new( fragment: 'Hotel Details<br />' ).clean!( from: 'br', to: 'div' ).to_s.should == '<div>Hotel Details</div>'
      end

    end

  end

end
