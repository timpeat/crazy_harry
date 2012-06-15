require 'spec_helper'

describe CrazyHarry::Cleaner do

  #   Change br to p
  #   Change b to h3 where b has text: "location"
  #   Change b to em where b inside p

  context "change" do
    subject { CrazyHarry::Cleaner }

    it "should be able to change one tag to another" do
      subject.new( fragment: '<b>Location:</b>' ).change( from: 'b', to: 'h3' ).run!.should == '<h3>Location:</h3>'
    end

    it "should be able to change all the tags it finds" do
      subject.new( fragment: '<b>1</b>, <b>2</b>, <b>3</b>' ).change( from: 'b', to: 'h3' ).run!.should == '<h3>1</h3>, <h3>2</h3>, <h3>3</h3>'
    end

    it "should be able to change an isolated br to a p" do
      subject.new( fragment: 'Hotel Details<br />' ).change( from: 'br', to: 'p' ).run!.should == '<p>Hotel Details</p>'
    end

    it "should be able to change multiple br tags to a single p" do
      subject.new( fragment: 'Hotel Details<br /><br /><br />' ).change( from: 'br', to: 'p' ).run!.should == '<p>Hotel Details</p>'
    end

    it "should be able to change all br tags to wrapped p tags" do
      subject.new( fragment: "hotel<br /> hostel<br /> tent<br />").change( from: 'br', to: 'p').run!.should ==
        '<p>hotel</p><p>hostel</p><p>tent</p>'
    end

    it "should be able to change a br tag to a div" do
      subject.new( fragment: 'Hotel Details<br />' ).change( from: 'br', to: 'div' ).run!.should == '<div>Hotel Details</div>'
    end

    it "should be able to change a span tag to a div" do
      subject.new( fragment: '<span>Hotel Details</span>' ).change( from: 'span', to: 'div' ).run!.should == '<div>Hotel Details</div>'
    end

    it "should not change things that it isn't directed to" do
      subject.new( fragment: '<h3>Hotel Details</h3>' ).change( from: 'span', to: 'div' ).run!.should == '<h3>Hotel Details</h3>'
    end

    it "shouldn't choke if it gets invalid tags" do
      subject.new( fragment: '<h3>Hotel Details</h3>' ).change( from: 'snoogenflozen', to: 'snarglebat' ).run!.should == '<h3>Hotel Details</h3>'
    end

    it "should be able to target changes by content" do
      subject.new( fragment: 'Hot <b>hotels</b> in <b>Saigon</b>' ).change( from: 'b', to: 'em', text: 'hotels').run!.should ==
        'Hot <em>hotels</em> in <b>Saigon</b>'
    end

  end

end
