require 'spec_helper'

describe CrazyHarry::Change do

  #   Change br to p
  #   Change b to h3 where b has text: "location"
  #   Change b to em where b inside p
  #
  #   Add attribute: "partner" to all tags
  #
  #   Another ADS suggestion.  Not sure it if it needed for the first cut.
  #   Transform "lodging" to "hotel"

  context "change" do

    let(:harry){ CrazyHarry }

    it "should be able to change one tag to another" do
      harry.fragment( '<b>Location:</b>' ).change!( from: 'b', to: 'h3' ).to_s.should == '<h3>Location:</h3>'
    end

    it "should unwrap unnecessary paragraphs" do
      harry.fragment('<p><strong>Header</strong><br /></p>').change!(from: 'strong', to: 'h3').to_s.should == 
        '<h3>Header</h3>'
    end

    it "should not unwrap paragraphs indiscriminately" do
      harry.fragment('<p><b>Header</b><br />Content</p>').change!(from: 'b', to: 'h3').to_s.should ==
        '<p><h3>Header</h3>Content</p>'
    end

    it "should wrap orphaned list items" do
      harry.fragment('<p><li>orphan</li><ul><li>item</li></p>').change!(from: 'b', to: 'h3').to_s.should ==
        '<ul><li>orphan</li></ul><ul><li>item</li></ul>'
    end
    
    context "chaining" do

       it "should be able to chain calls" do
        harry.fragment(  '<b>Location:</b><br />Saigon' ).change!( from: 'b', to: 'h3').change!( from: 'br', to: 'p' ).to_s.should ==
          '<h3>Location:</h3><p>Saigon</p>'
      end

      it "should not care about the order of the chain" do
        harry.fragment(  '<b>Location:</b><br />Saigon' ).change!( from: 'br', to: 'p' ).change!( from: 'b', to: 'h3' ).to_s.should ==
          '<h3>Location:</h3><p>Saigon</p>'
      end

    end

    it "should be able to change all the tags it finds" do
      harry.fragment( '<b>1</b><b>2</b><b>3</b>' ).change!( from: 'b', to: 'h3' ).to_s.should == '<h3>1</h3><h3>2</h3><h3>3</h3>'
    end

    it "should be able to change a span tag to a div" do
      harry.fragment( '<span>Hotel Details</span>' ).change!( from: 'span', to: 'div' ).to_s.should == '<div>Hotel Details</div>'
    end

    it "should not change things that it isn't directed to" do
      harry.fragment( '<h3>Hotel Details</h3>' ).change!( from: 'span', to: 'div' ).to_s.should == '<h3>Hotel Details</h3>'
    end

    it "shouldn't choke if it gets invalid tags" do
      harry.fragment( '<h3>Hotel Details</h3>' ).change!( from: 'snoogenflozen', to: 'snarglebat' ).to_s.should == '<h3>Hotel Details</h3>'
    end

    context "targeting and scoping" do

      it "should change all occurrences" do
       harry.fragment( '<div><b>Hotels</b></div><p><b>Hotels</b></p><b>Tents</b><div><p><b>Campervan</b></p></div>' ).change!( from: 'b', to: 'em').to_s.should ==
          '<div><em>Hotels</em></div><p><em>Hotels</em></p><em>Tents</em><div><p><em>Campervan</em></p></div>'
      end

      it "should be able to target changes by content" do
        harry.fragment( 'Hot <b>hotels</b> in <b>Saigon</b>' ).change!( from: 'b', to: 'em', text: 'hotels' ).to_s.should ==
          'Hot <em>hotels</em> in <b>Saigon</b>'
      end

      it "should be able to scope changes to specific blocks" do
        harry.fragment( '<div><b>Hotels</b></div><p><b>Hotels</b></p><b>Tents</b>' ).change!( from: 'b', to: 'em', scope: 'p' ).to_s.should ==
          '<div><b>Hotels</b></div><p><em>Hotels</em></p><b>Tents</b>'
      end

    end

  end
 
end
